# ──────────────────────────────────────────────────────────────────────────────
# Makefile — Flutter Clean Architecture
# Usage: make <target>
# ──────────────────────────────────────────────────────────────────────────────

.PHONY: help get clean clean-build build-runner watch \
        format format-check lint fix check ci \
        test test-verbose test-coverage test-watch \
        run run-dev run-staging run-prod \
        build-apk build-apk-dev build-apk-staging build-apk-prod \
        build-aab build-aab-prod \
        build-ios build-ios-prod \
        firebase-deploy-dev firebase-deploy-staging \
        splash icons \
        doctor outdated upgrade git-log

APP_NAME   := flutter_clean_architecture
FLUTTER    := flutter
DART       := dart

# ── Help ──────────────────────────────────────────────────────────────────────
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-28s\033[0m %s\n", $$1, $$2}'

# ── Setup ─────────────────────────────────────────────────────────────────────
get: ## flutter pub get
	$(FLUTTER) pub get

upgrade: ## flutter pub upgrade
	$(FLUTTER) pub upgrade

outdated: ## Check outdated packages
	$(FLUTTER) pub outdated

doctor: ## flutter doctor -v
	$(FLUTTER) doctor -v

# ── Code generation ───────────────────────────────────────────────────────────
build-runner: ## Run build_runner once (freezed, json, riverpod, auto_route)
	$(DART) run build_runner build --delete-conflicting-outputs

watch: ## Run build_runner in watch mode
	$(DART) run build_runner watch --delete-conflicting-outputs

# ── Clean ─────────────────────────────────────────────────────────────────────
clean: ## flutter clean + remove generated files
	$(FLUTTER) clean
	find lib test -name "*.g.dart" -delete
	find lib test -name "*.freezed.dart" -delete
	find lib test -name "*.gr.dart" -delete
	find lib test -name "*.config.dart" -delete
	@echo "✅ Cleaned"

clean-build: clean get build-runner ## Full clean → pub get → build_runner

# ── Format & Lint ─────────────────────────────────────────────────────────────
format: ## dart format all files (auto-fix)
	$(DART) format lib test

format-check: ## Check format without modifying files (dùng trong CI)
	$(DART) format --set-exit-if-changed lib test

lint: ## flutter analyze + custom_lint (riverpod_lint)
	$(FLUTTER) analyze lib
	$(DART) run custom_lint

fix: ## dart fix --apply
	$(DART) fix --apply lib

check: format lint ## format + lint (flutter analyze + custom_lint)

ci: format-check lint test ## Full CI check: format-check + lint + test

# ── Test ──────────────────────────────────────────────────────────────────────
test: ## Run all unit tests
	$(FLUTTER) test

test-verbose: ## Run tests with verbose output
	$(FLUTTER) test --reporter expanded

test-coverage: ## Run tests + generate coverage (requires lcov)
	$(FLUTTER) test --coverage
	genhtml coverage/lcov.info -o coverage/html
	@echo "📊 Open coverage/html/index.html"

test-watch: ## Run tests in watch mode (requires fswatch)
	fswatch -o lib test | xargs -n1 -I{} $(FLUTTER) test

# ── Run ───────────────────────────────────────────────────────────────────────
run: ## Run app (debug, default device)
	$(FLUTTER) run

run-dev: ## Run app with dev flavor
	$(FLUTTER) run --flavor dev --target lib/main_dev.dart

run-staging: ## Run app with staging flavor
	$(FLUTTER) run --flavor staging --target lib/main_staging.dart

run-prod: ## Run app with prod flavor
	$(FLUTTER) run --flavor prod --target lib/main_prod.dart

# ── Build APK ─────────────────────────────────────────────────────────────────
build-apk: ## Build debug APK
	$(FLUTTER) build apk --debug

build-apk-dev: ## Build dev APK (release)
	$(FLUTTER) build apk --flavor dev --target lib/main_dev.dart --release

build-apk-staging: ## Build staging APK (release)
	$(FLUTTER) build apk --flavor staging --target lib/main_staging.dart --release

build-apk-prod: ## Build production APK (release)
	$(FLUTTER) build apk --flavor prod --target lib/main_prod.dart --release
	@echo "📦 APK: build/app/outputs/flutter-apk/app-prod-release.apk"

# ── Build AAB (Play Store) ────────────────────────────────────────────────────
build-aab: ## Build debug AAB
	$(FLUTTER) build appbundle --debug

build-aab-prod: ## Build production AAB (release)
	$(FLUTTER) build appbundle --flavor prod --target lib/main_prod.dart --release
	@echo "📦 AAB: build/app/outputs/bundle/prodRelease/app-prod-release.aab"

# ── Build iOS ─────────────────────────────────────────────────────────────────
build-ios: ## Build iOS (debug, no codesign)
	$(FLUTTER) build ios --debug --no-codesign

build-ios-prod: ## Build iOS (release)
	$(FLUTTER) build ios --flavor prod --target lib/main_prod.dart --release

# ── Firebase ──────────────────────────────────────────────────────────────────
firebase-deploy-dev: ## Deploy to Firebase App Distribution (dev)
	$(FLUTTER) build apk --flavor dev --target lib/main_dev.dart --release
	firebase appdistribution:distribute build/app/outputs/flutter-apk/app-dev-release.apk \
		--app $(FIREBASE_APP_ID_DEV) \
		--groups "testers"

firebase-deploy-staging: ## Deploy to Firebase App Distribution (staging)
	$(FLUTTER) build apk --flavor staging --target lib/main_staging.dart --release
	firebase appdistribution:distribute build/app/outputs/flutter-apk/app-staging-release.apk \
		--app $(FIREBASE_APP_ID_STAGING) \
		--groups "testers"

# ── Assets ────────────────────────────────────────────────────────────────────
splash: ## Generate splash screen (flutter_native_splash)
	$(DART) run flutter_native_splash:create

icons: ## Generate app icons (flutter_launcher_icons)
	$(DART) run flutter_launcher_icons

# ── Git helpers ───────────────────────────────────────────────────────────────
git-log: ## Pretty git log
	git log --oneline --graph --decorate -20
