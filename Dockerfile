# Используем базовый образ Dart
FROM dart:latest

# Установка dart_frog_cli
RUN dart pub global activate dart_frog_cli

WORKDIR /app

# Копирование исходного кода
COPY . .

# Копирование pubspec файлов и загрузка зависимостей
RUN dart pub get

RUN dart pub install mysql_client
# Установка переменной среды для доступа к глобальным пакетам
ENV PATH="$PATH:/root/.pub-cache/bin"

# Команда для запуска вашего приложения при старте контейнера
CMD ["dart", "srv.dart"]