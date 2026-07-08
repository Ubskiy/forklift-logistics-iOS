import SwiftUI

enum AppConstants {
    enum API {
        static let baseURL = "https://api.forklift-logistics.ru"
        static let compareSummaryPath = "/compare/summary"
        static let compareRoutesPath = "/compare/routes"
        static let compareTripsPath = "/compare/trips"
        static let jsonContentType = "application/json"
        static let acceptHeader = "Accept"
        static let contentTypeHeader = "Content-Type"
        static let successStatusRange = 200...299
    }

    enum NumberFormat {
        static let twoDecimals = "%.2f"
        static let hms = "%02d:%02d:%02d"
        static let plus = "+"
        static let empty = ""
        static let percent = "%"
    }

    enum Time {
        static let secondsInMinute = 60
        static let secondsInHour = 3600
        static let minutesInHour = 60.0
        static let minutesInHourInt = 60
        static let minuteUnit = "мин"
        static let hourUnit = "ч"
    }

    enum Layout {
        static let screenSpacing: CGFloat = 16
        static let cardSpacing: CGFloat = 14
        static let compactSpacing: CGFloat = 8
        static let tinySpacing: CGFloat = 4
        static let mediumSpacing: CGFloat = 12
        static let cardPadding: CGFloat = 16
        static let metricPadding: CGFloat = 14
        static let tipPadding: CGFloat = 12
        static let cardCornerRadius: CGFloat = 22
        static let metricCornerRadius: CGFloat = 18
        static let tipCornerRadius: CGFloat = 16
        static let shadowOpacity: Double = 0.06
        static let shadowRadius: CGFloat = 14
        static let shadowYOffset: CGFloat = 8
        static let metricValueFontSize: CGFloat = 28
        static let iconCircle: CGFloat = 42
        static let helpCardMinHeight: CGFloat = 126
        static let timelineLabelWidth: CGFloat = 48
        static let timelineRowHeight: CGFloat = 36
        static let timelineTripHeight: CGFloat = 28
        static let timelineRowTotalHeight: CGFloat = 50
        static let timelineMinBarWidth: CGFloat = 3
        static let legendMinWidth: CGFloat = 92
        static let legendDotSize: CGFloat = 10
        static let forkliftBadgeHorizontalPadding: CGFloat = 8
        static let forkliftBadgeVerticalPadding: CGFloat = 4
        static let buttonCornerRadius: CGFloat = 18
        static let strategyToggleHeight: CGFloat = 42
        static let strategyToggleCornerRadius: CGFloat = 14
        static let strategyTogglePadding: CGFloat = 3
        static let forkliftToggleHeight: CGFloat = 38
        static let forkliftToggleCornerRadius: CGFloat = 12
        static let stickyControlsPadding: CGFloat = 10
    }

    enum Opacity {
        static let routeBackground = 0.14
        static let accentBackground = 0.10
        static let warningBackground = 0.10
        static let metricBackground = 0.09
        static let helpIconBackground = 0.12
    }

    enum Route {
        static let sC1 = "S->C1"
        static let c1C2 = "C1->C2"
        static let c2C3 = "C2->C3"
        static let c3C4 = "C3->C4"
        static let c4P = "C4->P"
        static let all = [sC1, c1C2, c2C3, c3C4, c4P]
    }

    enum Forklift {
        static let apiPrefix = "FL-"
        static let firstID = "FL-1"
        static let secondID = "FL-2"
        static let fullTitlePrefix = "Погрузчик №"
        static let shortTitlePrefix = "№"
        static let allFilterTitle = "Все"
    }

    enum ScenarioLimits {
        static let planRange = 20...160
        static let planStep = 2
        static let durationRange = 6.0...16.0
        static let durationStep = 0.5
        static let iterationsRange = 20...1500
        static let iterationsStep = 20
        static let sourceTubesRange = 0...1000
        static let c1TubesRange = 0...120
        static let inventoryRange = 0...80
        static let productionRateRange = 2.0...20.0
        static let c3RateRange = 2.0...16.0
        static let c3RateStep = 0.5
        static let handlingRange = 1.0...15.0
        static let handlingStep = 0.5
        static let travelRange = 0.2...10.0
        static let travelStep = 0.1
        static let underproductionPenaltyRange = 1000.0...100000.0
        static let underproductionPenaltyStep = 500.0
        static let makespanWeightRange = 0.0...100.0
        static let makespanWeightStep = 0.5
        static let c3StarvationWeightRange = 0.0...200.0
        static let c3StarvationWeightStep = 1.0
        static let forkliftIdleWeightRange = 0.0...100.0
        static let forkliftIdleWeightStep = 0.5
        static let initialTemperatureRange = 100.0...100000.0
        static let initialTemperatureStep = 500.0
        static let coolingRateRange = 0.90...0.999
        static let coolingRateStep = 0.001
        static let minTemperatureRange = 0.001...10.0
        static let minTemperatureStep = 0.01
        static let seedRange = 0...1_000_000
    }

    enum SFIcon {
        static let tip = "lightbulb.max.fill"
        static let tray = "tray"
        static let dashboard = "speedometer"
        static let timeline = "chart.bar.xaxis"
        static let trips = "list.bullet.rectangle"
        static let routes = "arrow.triangle.branch"
        static let help = "questionmark.circle"
        static let shipping = "shippingbox"
        static let greedy = "arrow.up.forward.circle"
        static let annealing = "flame"
        static let objective = "function"
        static let warning = "exclamationmark.triangle"
        static let sliders = "slider.horizontal.3"
        static let chevronDown = "chevron.down"
        static let chevronRight = "chevron.right"
    }

    enum Text {
        enum Common {
            static let scenario = "Сценарий"
            static let greedyShort = "Жадная"
            static let annealingShort = "Отжиг"
            static let greedyFull = "Жадная стратегия"
            static let annealingFull = "Имитация отжига"
            static let shieldsUnit = "щитов"
            static let piecesUnit = "шт"
            static let kgUnit = "кг"
            static let routesTitle = "Маршруты"
            static let timelineTitle = "Таймлайн"
            static let tripsTitle = "Журнал рейсов"
            static let helpTitle = "Справка"
            static let calculationTitle = "Расчёт"
        }

        enum Dashboard {
            static let navigationTitle = "Логистика цеха"
            static let cardTitle = "Диспетчерский расчёт"
            static let cardSubtitle = "Сравнение жадной стратегии и имитации отжига"
            static let resultTipTitle = "Как читать результат"
            static let resultTipMessage = "Главная метрика — отгружено щитов. Если отгрузка одинаковая, сравнивайте простой C3, общее время и структуру рейсов."
            static let scenarioTipTitle = "Где настроить сценарий"
            static let scenarioTipMessage = "Параметры смены, план, остатки и итерации настраиваются справа сверху на кнопке «Сценарий»."
            static let launchTitle = "Запуск"
            static let loadingButton = "Идёт расчёт..."
            static let runButton = "Запустить расчёт"
            static let errorTitle = "Ошибка расчёта"
            static let summaryTitle = "Итог сравнения"
            static let shippedSubtitle = "отгружено"
            static let c3Idle = "Простой C3"
            static let objective = "Целевая функция"
            static let lowerIsBetter = "меньше — лучше"
            static let comparisonTableTitle = "Подробная статистика"
            static let comparisonTableSubtitle = "Сравнение двух стратегий по ключевым метрикам"
            static let metricName = "Метрика"
            static let emptyTitle = "Пока нет расчёта"
            static let emptyMessage = "Настройте сценарий справа сверху на кнопке «Сценарий», затем нажмите «Запустить расчёт». После ответа backend появятся метрики, маршруты, журнал рейсов и нативный таймлайн."
            static let planPrefix = "План"
            static let forkliftUtilization = "загрузка погрузчиков"
            static let shipped = "Отгружено щитов"
            static let shortfall = "Недовыпуск"
            static let makespan = "Общее время"
            static let tripCount = "Количество рейсов"
            static let avgLoadUnits = "Средняя партия"
            static let avgLoadFactor = "Средняя загрузка рейса"
            static let emptyTravel = "Порожние перегоны"
            static let strategySelectorTitle = "Выбор стратегии"
        }

        enum Tabs {
            static let noTimelineMessage = "Сначала запустите расчёт на главном экране."
            static let noTripsMessage = "После расчёта здесь появится последовательность рейсов по времени."
            static let noRoutesMessage = "После расчёта здесь появится статистика по маршрутам."
            static let loadingTripsMessage = "Загружаем журнал рейсов отдельным запросом. Так главный расчёт открывается быстрее."
            static let loadingRoutesMessage = "Загружаем статистику маршрутов отдельным запросом."
        }

        enum Scenario {
            static let dayShift = "Дневная смена"
            static let nightShift = "Ночная смена"
            static let settingsTitle = "Параметры смены"
            static let settingsSubtitle = "Базовые настройки расчёта"
            static let plan = "План отгрузки"
            static let duration = "Длительность"
            static let iterations = "Итерации отжига"
            static let dispatcherTipTitle = "Что менять диспетчеру в первую очередь"
            static let dispatcherTipMessage = "Для демонстрации обычно достаточно менять план, начальные остатки перед C3/C4 и число итераций. Если C3 простаивает, итоговая отгрузка почти всегда падает."
            static let initialInventoryTitle = "Начальные остатки"
            static let initialInventorySubtitle = "Полуфабрикаты на старте смены"
            static let sourceTubes = "Труб на складе"
            static let tubesAtC1 = "Труб в C1"
            static let shieldsAtC2 = "Щитов в C2"
            static let shieldsAtC3 = "Щитов в C3"
            static let finishedAtC4 = "Готовых в C4"
            static let handlingTitle = "Времена операций"
            static let handlingSubtitle = "Погрузка и выгрузка, мин"
            static let tubeLoad = "Погрузка труб"
            static let tubeUnload = "Выгрузка труб"
            static let shieldLoad = "Погрузка щитов"
            static let shieldUnload = "Выгрузка щитов"
            static let finishedLoad = "Погрузка готовой продукции"
            static let finishedUnload = "Выгрузка готовой продукции"
            static let travelTitle = "Время перемещения"
            static let travelSubtitle = "Минуты между зонами"
            static let productionTitle = "Производительность цехов"
            static let productionSubtitle = "Щитов в час"
            static let bottleneckTitle = "Узкое место"
            static let bottleneckSubtitle = "Производительность C3"
            static let objectiveTitle = "Веса целевой функции"
            static let objectiveSubtitle = "Как приложение сравнивает решения"
            static let underproductionPenalty = "Штраф за недовыпуск"
            static let makespanWeight = "Вес общего времени"
            static let c3StarvationWeight = "Вес простоя C3"
            static let forkliftIdleWeight = "Вес простоя погрузчиков"
            static let annealingTitle = "Параметры отжига"
            static let annealingSubtitle = "Настройки поиска расписания"
            static let initialTemperature = "Начальная температура"
            static let coolingRate = "Коэффициент охлаждения"
            static let minTemperature = "Минимальная температура"
            static let reproducibilityTitle = "Воспроизводимость"
            static let reproducibilitySubtitle = "Seed фиксирует случайные перестановки отжига"
            static let seed = "Seed"
            static let c1 = "C1"
            static let c2 = "C2"
            static let c3 = "C3"
            static let c4 = "C4"
            static let shieldsPerHour = "щитов/час"
        }

        enum Timeline {
            static let cardTitle = "Таймлайн погрузчиков"
            static let tipTitle = "Как читать график"
            static let tipMessage = "Каждая строка — отдельный погрузчик. Цвет блока показывает маршрут. Чем шире блок, тем дольше рейс с учётом порожнего перегона, погрузки, движения и выгрузки."
            static let start = "Старт"
            static let shift = "Смена"
            static let tripPrefix = "Рейс №"
            static let quantity = "Количество"
            static let weight = "вес"
            static let loading = "Погрузка"
            static let travel = "Движение"
            static let unloading = "Выгрузка"
        }

        enum Trips {
            static let picker = "Погрузчик"
            static let section = "Рейсы"
            static let weight = "Вес"
            static let loading = "Погрузка"
            static let travel = "движение"
            static let unloading = "выгрузка"
        }

        enum Routes {
            static let tipTitle = "Что показывает статистика маршрутов"
            static let tipMessage = "Здесь видно, какие плечи цепочки занимают больше рейсов и где перевозки идут мелкими партиями."
            static let trips = "Рейсов"
            static let avgBatch = "Ср. партия"
            static let shields = "Щитов"
            static let tubes = "Труб"
            static let weight = "Вес"
            static let time = "время"
            static let tripsShare = "доля рейсов"
        }

        enum Help {
            static let articles: [HelpArticleContent] = [
                HelpArticleContent(title: "Что делает приложение", message: "Отправляет параметры смены на backend, получает расчёт двух стратегий и показывает отгрузку, простой C3 и расписание погрузчиков.", icon: AppConstants.SFIcon.shipping),
                HelpArticleContent(title: "Жадная стратегия", message: "Выбирает ближайший доступный рейс с учётом приоритетов потока. Это быстрый базовый вариант для сравнения.", icon: AppConstants.SFIcon.greedy),
                HelpArticleContent(title: "Имитация отжига", message: "Меняет порядок рейсов, прогоняет варианты через симуляцию и сохраняет расписание с меньшим значением целевой функции.", icon: AppConstants.SFIcon.annealing),
                HelpArticleContent(title: "Целевая функция", message: "Главный вклад даёт недовыпуск. Дополнительно учитываются общее время, простой C3 и штрафуемый простой погрузчиков.", icon: AppConstants.SFIcon.objective),
                HelpArticleContent(title: "Простой C3", message: "C3 — узкое место. Если он ждёт входной поток, итоговая отгрузка обычно снижается.", icon: AppConstants.SFIcon.warning),
                HelpArticleContent(title: "Таймлайн", message: "Цветные блоки показывают занятость погрузчиков. По ним видно распределение маршрутов во времени.", icon: AppConstants.SFIcon.timeline),
                HelpArticleContent(title: "Что менять диспетчеру", message: "Начинайте с плана, стартовых остатков перед C3/C4 и числа итераций. Если план недостижим, будет большой недовыпуск.", icon: AppConstants.SFIcon.sliders)
            ]
        }

        enum APIError {
            static let invalidURL = "Некорректный адрес сервера."
            static let invalidResponse = "Сервер вернул некорректный ответ."
            static let serverStatusPrefix = "Ошибка сервера: HTTP"
            static let decodingFailed = "Не удалось прочитать ответ сервера."
            static let encodingFailed = "Не удалось подготовить запрос."
        }
    }
}

struct HelpArticleContent {
    let title: String
    let message: String
    let icon: String
}
