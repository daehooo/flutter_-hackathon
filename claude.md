🎯 프로젝트 개요

앱 이름: 하루 감정 기록 & 시각화 앱

목적: 사용자가 하루 감정을 기록하고, 시각적 피드백과 통계로 감정 패턴 확인

💻 기술 스택

프레임워크: Flutter

아키텍처: MVC (Feature별 폴더 구조)

상태 관리: setState 기반 단순 구조

차트/시각화: fl_chart (Scatter Plot)

UI/애니메이션: Flutter 기본 애니메이션 위젯

📁 폴더 구조 (MVC + Feature별)
lib/
 ├─ core/          # 공통 색상, 스타일, 상수
 ├─ features/
 │    ├─ home/     # 홈 화면 관련 MVC
 │    │     ├─ home_model.dart
 │    │     ├─ home_view.dart
 │    │     └─ home_controller.dart
 │    ├─ stats/    # 통계 화면 관련 MVC
 │    │     ├─ stats_model.dart
 │    │     ├─ stats_view.dart
 │    │     └─ stats_controller.dart
 │    └─ friends/  # 친구 감정 화면 관련 MVC
 │          ├─ friends_model.dart
 │          ├─ friends_view.dart
 │          └─ friends_controller.dart
 └─ main.dart


core: 앱 전체 공통 스타일, 색상, 유틸 정의

feature 단위 MVC: Model-View-Controller 분리, 기능별 독립성 확보

🏠 홈 화면

AppBar: 오늘 날짜(M월 D일)

9가지 감정 기록, 중복 가능

감정 클릭 시 Opacity 0→1 + Shadow 확대 애니메이션

📊 통계 화면

AppBar: ‘M월’, 좌우 화살표로 이전/다음 달 이동 가능

Scatter Plot:

X축: 요일, Y축: 클릭 횟수

9가지 감정별 이모지 표시

9월/10월 더미 데이터 포함

👫 친구 감정 화면

AppBar: "내 친구들의 현재 무드"

원형 아바타 아이템, 상하 진자 애니메이션

친구 정보: 이름 + 최빈 감정(점수 포함)

Flutter 기본 위젯만 사용

🌈 UI/UX 특징

토스, 네이버 스타일 깔끔 UI

core 폴더에서 색상/스타일 통일

통계 및 감정 기록 모두 사용자 중심 최적화