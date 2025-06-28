# Flutter Clean Architecture Makefile
# Sử dụng: make <command>

.PHONY: help install clean build run test coverage format lint analyze generate build-runner

# Default target - setup project (install + generate)
.DEFAULT_GOAL := setup

# Development Commands
install: pub-get
	@echo "✅ Dependencies installed"

pub-get:
	@echo "📦 Getting packages..."
	flutter pub get

pub-upgrade:
	@echo "📦 Upgrading packages..."
	flutter pub upgrade

clean:
	@echo "🧹 Cleaning project..."
	flutter clean
	flutter pub get

clean-all: clean
	@echo "🧹 Cleaning everything..."
	rm -rf build/
	rm -rf .dart_tool/
	rm -rf ios/Pods/
	rm -rf ios/Podfile.lock
	git clean -Xfd
	flutter clean
	flutter pub get

# Build Commands
build:
	@echo "🔨 Building project..."
	flutter build apk --debug

build-apk:
	@echo "📱 Building APK..."
	flutter build apk --release

build-appbundle:
	@echo "📦 Building App Bundle..."
	flutter build appbundle --release

build-ios:
	@echo "🍎 Building iOS..."
	flutter build ios --release

# Run Commands
run:
	@echo "🚀 Running app in debug mode..."
	flutter run

run-release:
	@echo "🚀 Running app in release mode..."
	flutter run --release

run-profile:
	@echo "🚀 Running app in profile mode..."
	flutter run --profile

# Testing Commands
test:
	@echo "🧪 Running tests..."
	flutter test

test-watch:
	@echo "🧪 Running tests in watch mode..."
	flutter test --watch

coverage:
	@echo "📊 Generating test coverage..."
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html
	@echo "📊 Coverage report generated at coverage/html/index.html"

# Code Quality Commands
format:
	@echo "🎨 Formatting code..."
	dart format lib/ test/

lint:
	@echo "🔍 Running linter..."
	flutter analyze

analyze:
	@echo "🔍 Running static analysis..."
	dart analyze

sort-imports:
	@echo "📝 Sorting imports..."
	dart run import_sorter:main

# Code Generation Commands
generate:
	@echo "⚙️ Generating code..."
	flutter packages pub run build_runner build --delete-conflicting-outputs

generate-watch:
	@echo "⚙️ Generating code in watch mode..."
	flutter packages pub run build_runner watch --delete-conflicting-outputs

# Firebase Commands
firebase-deploy:
	@echo "🔥 Deploying to Firebase..."
	firebase deploy

# Utility Commands
doctor:
	@echo "🏥 Running Flutter doctor..."
	flutter doctor

# Combined Commands
setup: install generate
	@echo "✅ Project setup complete"

pre-commit: format lint analyze test
	@echo "✅ Pre-commit checks passed"

build-runner: generate
	@echo "✅ Build runner completed"

# Platform specific commands
android-studio:
	@echo "🤖 Opening Android Studio..."
	open -a "Android Studio" .

ios-simulator:
	@echo "📱 Opening iOS Simulator..."
	open -a Simulator

# Development workflow
dev: install generate run
	@echo "✅ Development environment ready"

# Production workflow
prod: clean install generate build-appbundle
	@echo "✅ Production build ready"

# Quick development cycle
quick: format lint run
	@echo "✅ Quick development cycle completed" 