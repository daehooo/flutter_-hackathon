# Flutter 개발환경 설정 가이드

이 가이드는 macOS에서 Flutter 개발환경을 설정하는 상세한 단계별 안내서입니다.

## 1. 사전 요구사항 확인 및 설치

### 1.1 Homebrew 설치 확인
```bash
# Homebrew 설치 여부 확인
brew --version

# 설치되어 있지 않다면 설치
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 1.2 Git 설치 확인
```bash
# Git 설치 여부 확인
git --version

# 설치되어 있지 않다면 Homebrew로 설치
brew install git
```

### 1.3 Node.js 및 npm 설치 확인
```bash
# Node.js 버전 확인
node --version

# npm 버전 확인
npm --version

# 설치되어 있지 않다면 Homebrew로 설치
brew install node
```

## 2. FVM (Flutter Version Management) 설치

### 2.1 Homebrew를 통한 FVM 설치
```bash
# FVM tap 추가
brew tap leoafarias/fvm

# FVM 설치
brew install fvm

# 설치 확인
fvm --version
```

### 2.2 FVM 설정 디렉토리 생성
```bash
# FVM 홈 디렉토리 생성
mkdir -p ~/fvm
```

## 3. Flutter SDK 설치 (FVM 사용)

### 3.1 최신 stable 버전 설치
```bash
# 사용 가능한 Flutter 버전 확인
fvm releases

# 최신 stable 버전 설치
fvm install stable

# 설치된 Flutter 버전 목록 확인
fvm list
```

### 3.2 전역 기본 버전 설정
```bash
# stable 버전을 전역 기본값으로 설정
fvm global stable

# 설정 확인
fvm global
```

## 4. 환경 변수 설정

### 4.1 Shell 환경 확인
```bash
# 사용 중인 shell 확인
echo $SHELL
```

### 4.2 환경 변수 추가 (.zshrc 또는 .bash_profile)

#### zsh 사용자 (macOS 기본값)
```bash
# .zshrc 파일 열기
nano ~/.zshrc

# 또는 VS Code로 열기
code ~/.zshrc
```

다음 내용을 파일 끝에 추가:
```bash
# FVM Flutter Path
export PATH="$PATH:$HOME/fvm/default/bin"
export PATH="$PATH:$HOME/.pub-cache/bin"

# Flutter 환경 변수
export FLUTTER_ROOT="$HOME/fvm/default"
```

#### bash 사용자
```bash
# .bash_profile 파일 열기
nano ~/.bash_profile

# 또는 VS Code로 열기
code ~/.bash_profile
```

동일한 내용을 추가합니다.

### 4.3 환경 변수 적용
```bash
# zsh 사용자
source ~/.zshrc

# bash 사용자
source ~/.bash_profile
```

### 4.4 설정 확인
```bash
# Flutter 경로 확인
which flutter

# Flutter 버전 확인
flutter --version

# Flutter doctor 실행
flutter doctor
```

## 5. Dart/Flutter MCP 서버 설정

### 5.1 Dart 버전 확인
```bash
# Dart 버전 확인 (3.9+ 필요)
dart --version
```

### 5.2 MCP 서버 기능 활성화
```bash
# Dart SDK가 3.9 이상인지 확인
# FVM을 통해 설치한 Flutter에는 적절한 버전의 Dart가 포함됨

# Claude Code 설정 파일 생성 (필요시)
mkdir -p ~/.claude
touch ~/.claude/settings.json
```

### 5.3 MCP 서버 설정 추가
~/.claude/settings.json 파일에 다음 내용 추가:
```json
{
  "mcpServers": {
    "dart": {
      "enabled": true
    }
  }
}
```

## 6. Firebase MCP 설치

### 6.1 Firebase CLI 버전 확인
```bash
# 기존 Firebase CLI 버전 확인
firebase --version

# 버전이 13.21.0 미만이면 제거
npm uninstall -g firebase-tools
```

### 6.2 Firebase Tools 설치 (13.21.0+)
```bash
# 최신 버전의 Firebase Tools 설치
npm install -g firebase-tools@latest

# 설치된 버전 확인 (13.21.0 이상이어야 함)
firebase --version
```

### 6.3 Firebase 로그인
```bash
# Firebase에 로그인
firebase login
```

## 7. Gemini CLI 설치

### 7.1 npm을 통한 전역 설치
```bash
# Gemini CLI 설치
npm install -g @google/generative-ai-cli

# 또는 구체적인 패키지명이 다를 경우
npm install -g gemini-cli

# 설치 확인
gemini --version
```

### 7.2 Gemini API 키 설정 (선택사항)
```bash
# 환경 변수에 API 키 추가 (.zshrc 또는 .bash_profile)
echo 'export GEMINI_API_KEY="your-api-key-here"' >> ~/.zshrc
source ~/.zshrc
```

## 8. 설치 검증

### 8.1 모든 도구 버전 확인
```bash
# 각 도구가 올바르게 설치되었는지 확인
echo "=== 개발환경 설정 확인 ==="
echo "Homebrew: $(brew --version | head -1)"
echo "Git: $(git --version)"
echo "Node.js: $(node --version)"
echo "npm: $(npm --version)"
echo "FVM: $(fvm --version)"
echo "Flutter: $(flutter --version | head -1)"
echo "Dart: $(dart --version)"
echo "Firebase: $(firebase --version)"
echo "Gemini CLI: $(gemini --version 2>/dev/null || echo 'Not found')"
```

### 8.2 Flutter Doctor 실행
```bash
# Flutter 개발환경 진단
flutter doctor -v
```

## 9. 프로젝트별 Flutter 버전 관리

### 9.1 프로젝트에서 특정 Flutter 버전 사용
```bash
# 프로젝트 디렉토리로 이동
cd /path/to/your/project

# 프로젝트에서 사용할 Flutter 버전 설정
fvm use stable

# 또는 특정 버전 사용
fvm use 3.16.0

# .fvm 디렉토리가 생성되고 설정이 저장됨
```

### 9.2 프로젝트에서 FVM Flutter 사용
```bash
# FVM을 통한 Flutter 명령어 실행
fvm flutter pub get
fvm flutter run
fvm flutter build
```

## 10. 문제 해결

### 10.1 PATH 설정 문제
```bash
# PATH 확인
echo $PATH

# FVM Flutter 경로가 포함되어 있는지 확인
echo $PATH | grep fvm
```

### 10.2 권한 문제
```bash
# npm 전역 패키지 설치 시 권한 문제가 발생하면
sudo npm install -g firebase-tools@latest
sudo npm install -g @google/generative-ai-cli
```

### 10.3 캐시 정리
```bash
# Flutter 캐시 정리
flutter clean
flutter pub cache repair

# npm 캐시 정리
npm cache clean --force
```

## 11. 추가 권장 설정

### 11.1 VS Code Extensions
- Flutter
- Dart
- Firebase Explorer
- Flutter Intl

### 11.2 Android Studio 설정
- Flutter 플러그인 설치
- Dart 플러그인 설치

### 11.3 iOS 개발 환경 (macOS)
```bash
# Xcode 설치 확인
xcode-select --print-path

# CocoaPods 설치
sudo gem install cocoapods
```

## 완료!

이제 Flutter 개발환경이 성공적으로 설정되었습니다. 다음 명령어로 새 프로젝트를 시작할 수 있습니다:

```bash
# 새 Flutter 프로젝트 생성
fvm flutter create my_app

# 프로젝트로 이동
cd my_app

# 프로젝트 실행
fvm flutter run
```

## 참고사항

- FVM을 사용하면 프로젝트별로 다른 Flutter 버전을 관리할 수 있습니다
- 항상 `fvm flutter` 명령어를 사용하여 프로젝트별 Flutter 버전을 사용하세요
- 전역 Flutter 명령어를 사용하려면 `flutter` 명령어를 직접 사용하세요
- MCP 서버 기능은 Claude Code와의 통합을 위한 것입니다