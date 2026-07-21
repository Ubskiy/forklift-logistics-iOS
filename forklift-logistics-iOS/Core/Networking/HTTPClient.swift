import Foundation

protocol HTTPClientProtocol {
    func send<Request: Encodable, Response: Decodable>(_ endpoint: APIEndpoint, body: Request) async throws -> Response
}

final class URLSessionHTTPClient: HTTPClientProtocol {
    private let baseURL: URL
    private let session: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        baseURL: URL = URL(string: AppConstants.API.baseURL)!,
        session: URLSession = .shared,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
    }

    func send<Request: Encodable, Response: Decodable>(_ endpoint: APIEndpoint, body: Request) async throws -> Response {
        guard let url = URL(string: endpoint.path, relativeTo: baseURL) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = AppConstants.API.requestTimeout
        request.setValue(AppConstants.API.jsonContentType, forHTTPHeaderField: AppConstants.API.acceptHeader)
        request.setValue(AppConstants.API.jsonContentType, forHTTPHeaderField: AppConstants.API.contentTypeHeader)

        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            throw APIError.encodingFailed
        }

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            guard AppConstants.API.successStatusRange.contains(httpResponse.statusCode) else {
                throw APIError.serverStatus(httpResponse.statusCode)
            }
            do {
                return try decoder.decode(Response.self, from: data)
            } catch {
                throw APIError.decodingFailed
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.transport(error)
        }
    }
}
