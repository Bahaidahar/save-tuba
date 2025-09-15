# 📱 Save Tuba - Complete Features Structure

## 🏗️ Architecture Overview
Проект использует Clean Architecture с разделением на features. Каждая фича содержит свои роуты, страницы и бизнес-логику.

## 📂 Features Structure

### 🔐 Auth Feature (`lib/features/auth/`)
**Аутентификация и управление паролями**
```
auth/
├── presentation/
│   └── pages/
│       ├── login_page.dart
│       ├── register_page.dart
│       ├── forgot_password_page.dart
│       └── change_password_page.dart
```

**Routes:**
- `/login` - Страница входа
- `/register` - Страница регистрации
- `/forgot-password` - Восстановление пароля
- `/change-password` - Смена пароля

### 🎓 Main Feature (`lib/features/main/`)
**Основная функциональность приложения**
```
main/
├── domain/
│   ├── constants/
│   └── models/
├── presentation/
│   ├── pages/
│   │   ├── home_page.dart
│   │   ├── profile/
│   │   │   ├── profile_page.dart
│   │   │   └── widgets/
│   │   ├── tasks_page.dart
│   │   ├── achievements/
│   │   │   ├── achievements_page.dart
│   │   │   └── widgets/
│   │   ├── class/
│   │   │   ├── class_page.dart
│   │   │   └── games/
│   │   └── classroom/
│   │       ├── classroom_details_page.dart
│   │       ├── create_classroom_page.dart
│   │       └── join_classroom_page.dart
│   └── widgets/
```

**Routes:**
- `/home` - Главная страница
- `/profile` - Профиль пользователя
- `/tasks` - Задания
- `/achievements` - Достижения
- `/class` - Страница урока
- `/classrooms/:id` - Детали класса
- `/classrooms/create` - Создание класса
- `/classrooms/join` - Присоединение к классу

### 🏫 School Feature (`lib/features/school/`)
**Управление школами**
```
school/
└── presentation/
    └── pages/
        ├── schools_list_page.dart
        ├── school_details_page.dart
        ├── create_school_page.dart
        └── edit_school_page.dart
```

**Routes:**
- `/schools` - Список школ
- `/schools/:id` - Детали школы
- `/schools/create` - Создание школы
- `/schools/:id/edit` - Редактирование школы

### 👨‍💼 Admin Feature (`lib/features/admin/`)
**Административная панель**
```
admin/
└── presentation/
    └── pages/
        ├── admin_dashboard_page.dart
        ├── my_school_page.dart
        ├── school_users_page.dart
        ├── school_classrooms_page.dart
        └── invite_teacher_page.dart
```

**Routes:**
- `/admin` - Панель администратора
- `/admin/my-school` - Моя школа
- `/admin/users` - Пользователи школы
- `/admin/classrooms` - Классы школы
- `/admin/invite-teacher` - Приглашение учителя

### 📚 Curriculum Feature (`lib/features/curriculum/`)
**Управление учебной программой**
```
curriculum/
└── presentation/
    └── pages/
        ├── curriculum_dashboard_page.dart
        ├── grade_levels_page.dart
        ├── chapters_page.dart
        ├── lessons_page.dart
        └── activities_page.dart
```

**Routes:**
- `/curriculum` - Панель учебной программы
- `/curriculum/grades` - Уровни классов
- `/curriculum/chapters` - Главы
- `/curriculum/lessons` - Уроки
- `/curriculum/activities` - Активности

### 🏆 Badges Feature (`lib/features/badges/`)
**Система достижений и бейджей**
```
badges/
└── presentation/
    └── pages/
        └── badges_page.dart
```

**Routes:**
- `/badges` - Страница бейджей и достижений

### 🚀 Onboarding Feature (`lib/features/onboarding/`)
**Онбординг для новых пользователей**
```
onboarding/
└── presentation/
    ├── pages/
    │   ├── onboarding_page.dart
    │   └── guest_loading_page.dart
    └── widgets/
        └── education_terms_slider.dart
```

**Routes:**
- `/onboarding` - Страница онбординга
- `/guest-loading` - Загрузка для гостей

## 🎮 Game Routes
**Игровые активности**
- `/games/quiz/:activityId` - Викторина
- `/games/matching/:activityId` - Сопоставление
- `/games/sorting/:activityId` - Сортировка
- `/games/memory/:activityId` - Память
- `/games/fill-blank/:activityId` - Заполни пропуски
- `/games/open-answer/:activityId` - Открытый ответ
- `/games/ordering/:activityId` - Упорядочивание
- `/games/photo/:activityId` - Фото игра
- `/games/grouping/:activityId` - Группировка
- `/games/mastery/:activityId` - Мастерство
- `/games/knowledge-check/:activityId` - Проверка знаний

## 🛠️ Core Infrastructure

### 🌐 API Integration
**Полный API Repository** (`lib/core/repositories/api_repository.dart`)
- ✅ Аутентификация (логин, регистрация, гостевой вход)
- ✅ Управление токенами (обновление, выход)
- ✅ Профиль пользователя (получение, обновление, смена пароля, фото)
- ✅ Управление школами (CRUD операции)
- ✅ Управление классами (создание, присоединение, архивирование)
- ✅ Учебная программа (уровни, главы, уроки, активности)
- ✅ Администрирование (пользователи школы, приглашения)
- ✅ Бейджи и достижения
- ✅ Языки и типы активностей

### 🗺️ Navigation System
**Централизованная система роутов**
- `lib/core/routes/app_routes.dart` - Константы роутов
- `lib/core/routes/app_router.dart` - GoRouter конфигурация
- Поддержка параметров и query parameters
- Типизированная навигация

### 🎨 UI Components
**Переиспользуемые компоненты**
- `CustomInputField` - Поля ввода
- `CustomButton` - Кнопки
- `LanguageSelector` - Выбор языка
- `LoadingPage` - Загрузка
- `WelcomeModal` - Модальные окна

## 📊 Current Status
- ✅ **309 issues found** - только предупреждения и рекомендации стиля
- ✅ **0 critical errors** - проект компилируется без ошибок
- ✅ **Complete API coverage** - все endpoints из документации покрыты
- ✅ **Full routing system** - все фичи имеют роуты
- ✅ **Clean architecture** - соблюдена структура проекта

## 🚀 Next Steps
1. **Локализация** - Добавить переводы для всех строк
2. **Бизнес-логика** - Реализовать BLoC/Cubit для управления состоянием
3. **UI/UX** - Доработать дизайн страниц
4. **Тестирование** - Добавить unit и widget тесты
5. **Оптимизация** - Исправить предупреждения анализатора

Структура готова к разработке! 🎉
