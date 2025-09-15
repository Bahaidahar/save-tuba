import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Onboarding
      'onboarding_title_1': 'Effective Learning',
      'onboarding_subtitle_1': 'Learn efficiently with our proven methods',
      'onboarding_title_2': 'Track Progress',
      'onboarding_subtitle_2': 'Monitor your learning journey',
      'onboarding_title_3': 'Develop Skills',
      'onboarding_subtitle_3': 'Build new skills step by step',
      'get_started': 'Get Started',
      'skip': 'Skip',
      'welcome_title': 'Welcome to Save Tuba!',
      'welcome_subtitle':
          'A sustainability education application for Kazakhstan\'s youngest citizens',

      // Auth
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'dont_have_account': "Don't have an account?",
      'already_have_account': 'Already have an account?',
      'sign_up': 'Sign Up',
      'sign_in': 'Sign In',
      'continue_as_guest': 'Continue as a guest',
      'first_name': 'First name',
      'last_name': 'Last name',
      'back': 'Back',
      'go': 'Go!',
      'please_enter_email': 'Please enter your email',
      'please_enter_valid_email': 'Please enter a valid email',
      'please_enter_password': 'Please enter your password',
      'password_min_length': 'Password must be at least 6 characters',
      'please_enter_first_name': 'Please enter your first name',
      'please_enter_last_name': 'Please enter your last name',

      // Main App
      'home': 'Home',
      'tasks': 'Tasks',
      'class': 'Class',
      'profile': 'Profile',

      // Profile
      'settings': 'Settings',
      'language': 'Language',
      'change_language': 'Change Language',
      'support': 'Support',
      'about_us': 'About Us',
      'get_help': 'Get Help',
      'learn_more_about_app': 'Learn more about the app',
      'logout': 'Logout',
      'logout_confirmation': 'Are you sure you want to logout?',
      'cancel': 'Cancel',
      'yes': 'Yes',
      'no': 'No',
      'error_loading_profile': 'Error loading profile',
      'please_try_again': 'Please try again',
      'number_of_students': 'Number of students',

      // Tasks
      'add_task': 'Add Task',
      'task_title': 'Task Title',
      'task_description': 'Task Description',
      'due_date': 'Due Date',
      'priority': 'Priority',
      'high': 'High',
      'medium': 'Medium',
      'low': 'Low',
      'completed': 'Completed',
      'pending': 'Pending',
      'current_tasks': 'Current',
      'overdue_tasks': 'Overdue',
      'completed_tasks': 'Completed',
      'no_current_tasks': 'No current tasks',
      'no_overdue_tasks': 'No overdue tasks',
      'no_completed_tasks': 'No completed tasks',
      'tasks_will_appear_here': 'Tasks will appear here',
      'today': 'Today',
      'tomorrow': 'Tomorrow',
      'yesterday': 'Yesterday',
      'in_days': 'In {days} days',
      'days_ago': '{days} days ago',

      // Class module
      'classes': 'Classes',
      'retry': 'Retry',
      'demo_data': 'Demo Data',
      'refresh': 'Refresh',
      'error_loading_data': 'Error loading data',
      'classes_not_found': 'Classes not found',
      'try_refreshing': 'Try refreshing the page',
      'unknown_error': 'Unknown error',

      // Ordering game
      'arrange_elements_correctly': 'Arrange the elements in the correct order',
      'winter': 'Winter',
      'spring': 'Spring',
      'summer': 'Summer',
      'autumn': 'Autumn',
      'excellent': 'Excellent!',
      'all_elements_correct': 'All elements are arranged in the correct order!',
      'almost_correct': 'Almost correct!',
      'correct_positions':
          'Correctly placed: {correct} out of {total} elements.',
      'continue': 'Continue',
      'hint': 'Hint',
      'reset': 'Reset',
      'check': 'Check',
      'correct_order': 'Correct order:',
      'arrangement_game': 'Arrangement Game',
      'hold_and_drag': 'Hold and drag elements to change order',
      'hint_text':
          'Hint: "{item}" should be at position {position}, currently at position {current}',
      'full_leaderboard_coming_soon': 'Full leaderboard coming soon!',
      'no_badges_available': 'No badges available',
      'error_occurred': 'An error occurred: {error}',
      'classroom': 'Classroom',
      'view_classroom': 'View Classroom',
      'access_your_classes': 'Access your classes and lessons',

      // Class
      'class_code': 'Class Code',
      'teacher': 'Teacher',
      'students': 'Students',
      'assignments': 'Assignments',
      'materials': 'Materials',
      'class_information': 'Class Information',
      'students_in_class': 'Students in class',

      // Achievements
      'achievements': 'Achievements',
      'points': 'Points',
      'level': 'Level',
      'next_level': 'Next Level',
      'progress': 'Progress',
      'level_number': 'Level {number}',
      'progress_to_next_level': 'Progress to next level',
      'xp_format': '{current} / {total} XP',
      'leaderboard': 'Leaderboard',
      'rewards': 'Rewards',
      'first_victory': 'First Victory',
      'star_student': 'Star Student',
      'eco_hero': 'Eco Hero',
      'diamond_level': 'Diamond Level',
      'premium': 'Premium',
      'sage': 'Sage',

      // Common
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'close': 'Close',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'warning': 'Warning',
      'info': 'Information',
      'setting_up_guest_mode': 'Setting up guest mode...',

      // Welcome Modal
      'welcome_modal_title': "Hello! I'm Tuba",
      'welcome_modal_intro':
          "I am a saiga antelope, a species native to the Kazakh steppes and currently under threat of extinction.",
      'welcome_modal_mission':
          "Help me complete tasks that improve our environment.\nWelcome to my world!",
      'welcome_modal_continue': 'Continue',

      // Education Terms
      'education': 'Education',
      'schooling': 'Schooling',
      'instruction': 'Instruction',
      'teaching': 'Teaching',
      'curriculum': 'Curriculum',
      'learning': 'Learning',
    },
    'ru': {
      // Onboarding
      'onboarding_title_1': 'Эффективное обучение',
      'onboarding_subtitle_1':
          'Учитесь эффективно с нашими проверенными методами',
      'onboarding_title_2': 'Отслеживание прогресса',
      'onboarding_subtitle_2': 'Следите за своим учебным путем',
      'onboarding_title_3': 'Развитие навыков',
      'onboarding_subtitle_3': 'Развивайте новые навыки шаг за шагом',
      'get_started': 'Начать',
      'skip': 'Пропустить',
      'welcome_title': 'Добро пожаловать в  Save Tuba!',
      'welcome_subtitle':
          'Приложение для экологического образования самых юных граждан Казахстана',

      // Auth
      'login': 'Войти',
      'register': 'Регистрация',
      'email': 'Электронная почта',
      'password': 'Пароль',
      'confirm_password': 'Подтвердите пароль',
      'forgot_password': 'Забыли пароль?',
      'dont_have_account': 'Нет аккаунта?',
      'already_have_account': 'Уже есть аккаунт?',
      'sign_up': 'Зарегистрироваться',
      'sign_in': 'Войти',
      'continue_as_guest': 'Продолжить как гость',
      'first_name': 'Имя',
      'last_name': 'Фамилия',
      'back': 'Назад',
      'go': 'Вперед!',
      'please_enter_email': 'Пожалуйста, введите ваш email',
      'please_enter_valid_email': 'Пожалуйста, введите корректный email',
      'please_enter_password': 'Пожалуйста, введите ваш пароль',
      'password_min_length': 'Пароль должен содержать минимум 6 символов',
      'please_enter_first_name': 'Пожалуйста, введите ваше имя',
      'please_enter_last_name': 'Пожалуйста, введите вашу фамилию',

      // Main App
      'home': 'Главная',
      'tasks': 'Задачи',
      'class': 'Класс',
      'profile': 'Профиль',

      // Profile
      'settings': 'Настройки',
      'language': 'Язык',
      'change_language': 'Изменить язык',
      'support': 'Поддержка',
      'about_us': 'О нас',
      'get_help': 'Получить помощь',
      'learn_more_about_app': 'Узнать больше о приложении',
      'logout': 'Выйти',
      'logout_confirmation': 'Вы уверены, что хотите выйти?',
      'cancel': 'Отмена',
      'yes': 'Да',
      'no': 'Нет',
      'error_loading_profile': 'Ошибка загрузки профиля',
      'please_try_again': 'Попробуйте еще раз',
      'number_of_students': 'Количество учеников',

      // Tasks
      'add_task': 'Добавить задачу',
      'task_title': 'Название задачи',
      'task_description': 'Описание задачи',
      'due_date': 'Срок выполнения',
      'priority': 'Приоритет',
      'high': 'Высокий',
      'medium': 'Средний',
      'low': 'Низкий',
      'completed': 'Завершено',
      'pending': 'В ожидании',
      'current_tasks': 'Текущие',
      'overdue_tasks': 'Просроченные',
      'completed_tasks': 'Завершенные',
      'no_current_tasks': 'Нет текущих заданий',
      'no_overdue_tasks': 'Нет просроченных заданий',
      'no_completed_tasks': 'Нет завершенных заданий',
      'tasks_will_appear_here': 'Задания появятся здесь',
      'today': 'Сегодня',
      'tomorrow': 'Завтра',
      'yesterday': 'Вчера',
      'in_days': 'Через {days} дней',
      'days_ago': '{days} дней назад',

      // Class module
      'classes': 'Классы',
      'retry': 'Повторить',
      'demo_data': 'Демо данные',
      'refresh': 'Обновить',
      'error_loading_data': 'Ошибка загрузки данных',
      'classes_not_found': 'Классы не найдены',
      'try_refreshing': 'Попробуйте обновить страницу',
      'unknown_error': 'Неизвестная ошибка',

      // Ordering game
      'arrange_elements_correctly': 'Расставьте элементы в правильном порядке',
      'winter': 'Зима',
      'spring': 'Весна',
      'summer': 'Лето',
      'autumn': 'Осень',
      'excellent': 'Отлично!',
      'all_elements_correct': 'Все элементы расставлены в правильном порядке!',
      'almost_correct': 'Почти правильно!',
      'correct_positions':
          'Правильно размещено: {correct} из {total} элементов.',
      'continue': 'Продолжить',
      'hint': 'Подсказка',
      'reset': 'Сбросить',
      'check': 'Проверить',
      'correct_order': 'Правильный порядок:',
      'arrangement_game': 'Расстановка по порядку',
      'hold_and_drag':
          'Удерживайте и перетаскивайте элементы для изменения порядка',
      'hint_text':
          'Подсказка: "{item}" должен быть на позиции {position}, сейчас на позиции {current}',
      'full_leaderboard_coming_soon': 'Полная таблица лидеров скоро!',
      'no_badges_available': 'Достижения недоступны',
      'error_occurred': 'Произошла ошибка: {error}',
      'classroom': 'Класс',
      'view_classroom': 'Просмотр класса',
      'access_your_classes': 'Доступ к вашим классам и урокам',

      // Class
      'class_code': 'Код класса',
      'teacher': 'Учитель',
      'students': 'Ученики',
      'assignments': 'Задания',
      'materials': 'Материалы',
      'class_information': 'Информация о классе',
      'students_in_class': 'Ученики в классе',

      // Achievements
      'achievements': 'Достижения',
      'points': 'Очки',
      'level': 'Уровень',
      'next_level': 'Следующий уровень',
      'progress': 'Прогресс',
      'level_number': 'Уровень {number}',
      'progress_to_next_level': 'Прогресс к следующему уровню',
      'xp_format': '{current} / {total} XP',
      'leaderboard': 'Таблица лидеров',
      'rewards': 'Награды',
      'first_victory': 'Первая победа',
      'star_student': 'Звезда ученика',
      'eco_hero': 'Экогерой',
      'diamond_level': 'Алмазный уровень',
      'premium': 'Премиум',
      'sage': 'Сага',

      // Common
      'save': 'Сохранить',
      'delete': 'Удалить',
      'edit': 'Редактировать',
      'close': 'Закрыть',
      'loading': 'Загрузка...',
      'error': 'Ошибка',
      'success': 'Успех',
      'warning': 'Предупреждение',
      'info': 'Информация',
      'setting_up_guest_mode': 'Настройка режима гостя...',

      // Welcome Modal
      'welcome_modal_title': "Привет! Я Тюба",
      'welcome_modal_intro':
          "Я сайгак, вид антилоп, обитающий в казахстанских степях и в настоящее время находящийся под угрозой исчезновения.",
      'welcome_modal_mission':
          "Помоги мне выполнять задачи, которые улучшают нашу окружающую среду.\nДобро пожаловать в мой мир!",
      'welcome_modal_continue': 'Продолжить',

      // Education Terms
      'education': 'Образование',
      'schooling': 'Обучение',
      'instruction': 'Инструкция',
      'teaching': 'Преподавание',
      'curriculum': 'Учебная программа',
      'learning': 'Обучение',
    },
    'kz': {
      // Onboarding
      'onboarding_title_1': 'Тиімді оқу',
      'onboarding_subtitle_1':
          'Біздің дәлелденген әдістерімізбен тиімді оқыңыз',
      'onboarding_title_2': 'Прогресті бақылау',
      'onboarding_subtitle_2': 'Оқу жолыңызды бақылаңыз',
      'onboarding_title_3': 'Дағдыларды дамыту',
      'onboarding_subtitle_3': 'Жаңа дағдыларды қадам сайын дамытыңыз',
      'get_started': 'Бастау',
      'skip': 'Өткізу',
      'welcome_title': 'Save Tuba-ға  қош келдіңіз!',
      'welcome_subtitle':
          'Қазақстанның ең кішкентай азаматтарына арналған тұрақтылық білім беру қосымшасы',

      // Auth
      'login': 'Кіру',
      'register': 'Тіркелу',
      'email': 'Электрондық пошта',
      'password': 'Құпия сөз',
      'confirm_password': 'Құпия сөзді растау',
      'forgot_password': 'Құпия сөзді ұмыттыңыз ба?',
      'dont_have_account': 'Есептік жазбаңыз жоқ па?',
      'already_have_account': 'Есептік жазбаңыз бар ма?',
      'sign_up': 'Тіркелу',
      'sign_in': 'Кіру',
      'continue_as_guest': 'Қонақ ретінде жалғастыру',
      'first_name': 'Аты',
      'last_name': 'Тегі',
      'back': 'Артқа',
      'go': 'Кетті!',
      'please_enter_email': 'Электрондық поштаңызды енгізіңіз',
      'please_enter_valid_email': 'Жарамды электрондық пошта енгізіңіз',
      'please_enter_password': 'Құпия сөзіңізді енгізіңіз',
      'password_min_length': 'Құпия сөз кемінде 6 таңба болуы керек',
      'please_enter_first_name': 'Атыңызды енгізіңіз',
      'please_enter_last_name': 'Тегіңізді енгізіңіз',

      // Main App
      'home': 'Басты бет',
      'tasks': 'Тапсырмалар',
      'class': 'Сынып',
      'profile': 'Профиль',

      // Profile
      'settings': 'Баптаулар',
      'language': 'Тіл',
      'change_language': 'Тілді өзгерту',
      'support': 'Қолдау',
      'about_us': 'Біз туралы',
      'get_help': 'Көмек алу',
      'learn_more_about_app': 'Көпіршікті қосымшаның біз туралы',
      'logout': 'Шығу',
      'logout_confirmation': 'Шығғыңыз келетініне сенімдісіз бе?',
      'cancel': 'Бас тарту',
      'yes': 'Иә',
      'no': 'Жоқ',
      'error_loading_profile': 'Профильді жүктеу қатесі',
      'please_try_again': 'Қайталап көріңіз',
      'number_of_students': 'Оқушылар саны',

      // Tasks
      'add_task': 'Тапсырма қосу',
      'task_title': 'Тапсырма тақырыбы',
      'task_description': 'Тапсырма сипаттамасы',
      'due_date': 'Мерзімі',
      'priority': 'Басымдылық',
      'high': 'Жоғары',
      'medium': 'Орташа',
      'low': 'Төмен',
      'completed': 'Аяқталды',
      'pending': 'Күтуде',

      "current_tasks": "Ағымдағы",
      "overdue_tasks": "Мерзімі өткен",
      "completed_tasks": "Аяқталған",
      "no_current_tasks": "Ағымдағы тапсырмалар жоқ",
      "no_overdue_tasks": "Мерзімі өткен тапсырмалар жоқ",
      "no_completed_tasks": "Аяқталған тапсырмалар жоқ",
      "tasks_will_appear_here": "Тапсырмалар осында көрсетіледі",

      'today': 'Бүгін',
      'tomorrow': 'Ертең',
      'yesterday': 'Бүгін бұрын',
      'in_days': '{days} күннен кейін',
      'days_ago': '{days} күн бұрын',

      // Class module
      'classes': 'Сыныптар',
      'retry': 'Қайталау',
      'demo_data': 'Демо деректер',
      'refresh': 'Жаңарту',
      'error_loading_data': 'Деректерді жүктеу қатесі',
      'classes_not_found': 'Сыныптар табылмады',
      'try_refreshing': 'Бетті жаңартуға тырысыңыз',
      'unknown_error': 'Белгісіз қате',

      // Ordering game
      'arrange_elements_correctly': 'Элементтерді дұрыс ретпен орналастырыңыз',
      'winter': 'Қыс',
      'spring': 'Көктем',
      'summer': 'Жаз',
      'autumn': 'Күз',
      'excellent': 'Керемет!',
      'all_elements_correct': 'Барлық элементтер дұрыс ретпен орналастырылған!',
      'almost_correct': 'Дереу дұрыс!',
      'correct_positions':
          'Дұрыс орналастырылған: {correct} {total} элементтен.',
      'continue': 'Жалғастыру',
      'hint': 'Кеңес',
      'reset': 'Тазалау',
      'check': 'Тексеру',
      'correct_order': 'Дұрыс рет:',
      'arrangement_game': 'Ретпен орналастыру ойыны',
      'hold_and_drag': 'Ретті өзгерту үшін элементтерді ұстап сүйреңіз',
      'hint_text':
          'Кеңес: "{item}" {position} позицияда болуы керек, қазір {current} позицияда',
      'full_leaderboard_coming_soon': 'Толық көшбасшылар тақтасы жақында!',
      'no_badges_available': 'Жетістіктер қолжетімді емес',
      'error_occurred': 'Қате орын алды: {error}',
      'classroom': 'Сынып',
      'view_classroom': 'Сыныпты көру',
      'access_your_classes': 'Сыныптарыңызға және сабақтарыңызға кіру',

      // Class
      'class_code': 'Сынып коды',
      'teacher': 'Мұғалім',
      'students': 'Оқушылар',
      'assignments': 'Тапсырмалар',
      'materials': 'Материалдар',
      'class_information': 'Сынып мәліметтері',
      'students_in_class': 'Сыныптағы оқушылар',

      // Achievements
      'achievements': 'Жетістіктер',
      'points': 'Ұпайлар',
      'level': 'Деңгей',
      'next_level': 'Келесі деңгей',
      'progress': 'Прогресс',
      'level_number': 'Деңгей {number}',
      'progress_to_next_level': 'Келесі деңгейге өту',
      'xp_format': '{current} / {total} XP',
      "leaderboard": "Көшбасшылар тақтасы",
      "rewards": "Сыйлықтар",
      "first_victory": "Алғашқы жеңіс",
      "star_student": "Жұлдызды оқушы",
      "eco_hero": "Экобатыр",
      "diamond_level": "Гауһар деңгейі",
      "premium": "Премиум",
      "sage": "Дана",

      // Common
      'save': 'Сақтау',
      'delete': 'Жою',
      'edit': 'Өңдеу',
      'close': 'Жабу',
      'loading': 'Жүктелуде...',
      'error': 'Қате',
      'success': 'Сәтті',
      'warning': 'Ескерту',
      'info': 'Ақпарат',
      'setting_up_guest_mode': 'Қонақ режимін орнату...',

      // Welcome Modal
      'welcome_modal_title': "Сәлем! Мен Тұба",
      'welcome_modal_intro':
          "Мен сайгақ, Қазақстан далаларында тұратын және қазіргі уақытта жойылу қаупіндегі антилопа түрі.",
      'welcome_modal_mission':
          "Біздің қоршаған ортаны жақсартатын тапсырмаларды орындауға көмектес.\nМенің әлеміме қош келдің!",
      'welcome_modal_continue': 'Жалғастыру',

      // Education Terms
      'education': 'Білім беру',
      'schooling': 'Оқу',
      'instruction': 'Нұсқау',
      'teaching': 'Оқыту',
      'curriculum': 'Оқу бағдарламасы',
      'learning': 'Оқу',
    },
  };

  String get(String key) {
    // Map kk back to kz for our internal translations
    String languageCode = locale.languageCode;
    if (languageCode == 'kk') {
      languageCode = 'kz';
    }

    final translations =
        _localizedValues[languageCode] ?? _localizedValues['en']!;
    return translations[key] ?? key;
  }

  // Convenience methods for common translations
  String get onboardingTitle1 => get('onboarding_title_1');
  String get onboardingSubtitle1 => get('onboarding_subtitle_1');
  String get onboardingTitle2 => get('onboarding_title_2');
  String get onboardingSubtitle2 => get('onboarding_subtitle_2');
  String get onboardingTitle3 => get('onboarding_title_3');
  String get onboardingSubtitle3 => get('onboarding_subtitle_3');
  String get getStarted => get('get_started');
  String get skip => get('skip');
  String get welcomeTitle => get('welcome_title');
  String get welcomeSubtitle => get('welcome_subtitle');

  String get login => get('login');
  String get register => get('register');
  String get email => get('email');
  String get password => get('password');
  String get confirmPassword => get('confirm_password');
  String get forgotPassword => get('forgot_password');
  String get dontHaveAccount => get('dont_have_account');
  String get alreadyHaveAccount => get('already_have_account');
  String get signUp => get('sign_up');
  String get signIn => get('sign_in');
  String get continueAsGuest => get('continue_as_guest');
  String get firstName => get('first_name');
  String get lastName => get('last_name');
  String get back => get('back');
  String get go => get('go');
  String get pleaseEnterEmail => get('please_enter_email');
  String get pleaseEnterValidEmail => get('please_enter_valid_email');
  String get pleaseEnterPassword => get('please_enter_password');
  String get passwordMinLength => get('password_min_length');
  String get pleaseEnterFirstName => get('please_enter_first_name');
  String get pleaseEnterLastName => get('please_enter_last_name');

  String get home => get('home');
  String get tasks => get('tasks');
  String get classText => get('class');
  String get achievements => get('achievements');
  String get profile => get('profile');

  String get settings => get('settings');
  String get language => get('language');
  String get changeLanguage => get('change_language');
  String get support => get('support');
  String get aboutUs => get('about_us');
  String get getHelp => get('get_help');
  String get learnMoreAboutApp => get('learn_more_about_app');
  String get logout => get('logout');
  String get logoutConfirmation => get('logout_confirmation');
  String get cancel => get('cancel');
  String get yes => get('yes');
  String get no => get('no');
  String get errorLoadingProfile => get('error_loading_profile');
  String get pleaseTryAgain => get('please_try_again');
  String get numberOfStudents => get('number_of_students');

  String get addTask => get('add_task');
  String get taskTitle => get('task_title');
  String get taskDescription => get('task_description');
  String get dueDate => get('due_date');
  String get priority => get('priority');
  String get high => get('high');
  String get medium => get('medium');
  String get low => get('low');
  String get completed => get('completed');
  String get pending => get('pending');
  String get currentTasks => get('current_tasks');
  String get overdueTasks => get('overdue_tasks');
  String get completedTasks => get('completed_tasks');
  String get noCurrentTasks => get('no_current_tasks');
  String get noOverdueTasks => get('no_overdue_tasks');
  String get noCompletedTasks => get('no_completed_tasks');
  String get tasksWillAppearHere => get('tasks_will_appear_here');
  String get today => get('today');
  String get tomorrow => get('tomorrow');
  String get yesterday => get('yesterday');
  String get inDays => get('in_days');
  String get daysAgo => get('days_ago');

  // Class module getters
  String get classes => get('classes');
  String get retry => get('retry');
  String get demoData => get('demo_data');
  String get refresh => get('refresh');
  String get errorLoadingData => get('error_loading_data');
  String get classesNotFound => get('classes_not_found');
  String get tryRefreshing => get('try_refreshing');
  String get unknownError => get('unknown_error');

  // Ordering game getters
  String get arrangeElementsCorrectly => get('arrange_elements_correctly');
  String get winter => get('winter');
  String get spring => get('spring');
  String get summer => get('summer');
  String get autumn => get('autumn');
  String get excellent => get('excellent');
  String get allElementsCorrect => get('all_elements_correct');
  String get almostCorrect => get('almost_correct');
  String correctPositions(int correct, int total) => get('correct_positions')
      .replaceAll('{correct}', correct.toString())
      .replaceAll('{total}', total.toString());
  String get continue_ => get('continue');
  String get hint => get('hint');
  String get reset => get('reset');
  String get check => get('check');
  String get correctOrder => get('correct_order');
  String get arrangementGame => get('arrangement_game');
  String get holdAndDrag => get('hold_and_drag');
  String hintText(String item, int position, int current) => get('hint_text')
      .replaceAll('{item}', item)
      .replaceAll('{position}', position.toString())
      .replaceAll('{current}', current.toString());
  String get fullLeaderboardComingSoon => get('full_leaderboard_coming_soon');
  String get noBadgesAvailable => get('no_badges_available');
  String errorOccurred(String error) =>
      get('error_occurred').replaceAll('{error}', error);
  String get classroom => get('classroom');
  String get viewClassroom => get('view_classroom');
  String get accessYourClasses => get('access_your_classes');

  String get classCode => get('class_code');
  String get teacher => get('teacher');
  String get students => get('students');
  String get assignments => get('assignments');
  String get materials => get('materials');
  String get classInformation => get('class_information');
  String get studentsInClass => get('students_in_class');

  String get points => get('points');
  String get level => get('level');
  String get nextLevel => get('next_level');
  String get progress => get('progress');
  String get levelNumber => get('level_number');
  String get progressToNextLevel => get('progress_to_next_level');
  String get xpFormat => get('xp_format');
  String get leaderboard => get('leaderboard');
  String get rewards => get('rewards');
  String get firstVictory => get('first_victory');
  String get starStudent => get('star_student');
  String get ecoHero => get('eco_hero');
  String get diamondLevel => get('diamond_level');
  String get premium => get('premium');
  String get sage => get('sage');

  String get save => get('save');
  String get delete => get('delete');
  String get edit => get('edit');
  String get close => get('close');
  String get loading => get('loading');
  String get error => get('error');
  String get success => get('success');
  String get warning => get('warning');
  String get info => get('info');
  String get settingUpGuestMode => get('setting_up_guest_mode');

  // Welcome Modal
  String get welcomeModalTitle => get('welcome_modal_title');
  String get welcomeModalIntro => get('welcome_modal_intro');
  String get welcomeModalMission => get('welcome_modal_mission');
  String get welcomeModalContinue => get('welcome_modal_continue');

  // Education Terms
  String get education => get('education');
  String get schooling => get('schooling');
  String get instruction => get('instruction');
  String get teaching => get('teaching');
  String get curriculum => get('curriculum');
  String get learning => get('learning');
}
