# With-u
### DIVE 2024_다이빙갈매기
#### 이 프로젝트는 부산광역시 공공데이터 활용 해커톤 [DIVE2024](https://www.dxchallenge.co.kr/about-1)에서 삼정KPMG의 발제를 받아 진행했습니다.

## 프로젝트 소개
With-u는 WYD2027 행사를 위한 팀 관리 애플리케이션으로, 참가자들에게 더 나은 경험을 제공하고 행사 운영을 효율적으로 지원합니다.

## 주요 기능

1. **구성원 관리**
    - 팀별 구성원 관리 및 조직화

2. **공지사항 알림 시스템**
     - FCM(Firebase Cloud Messaging)을 이용한 푸시 알림 기능
     - 중요 공지사항 실시간 전달

3. **관광지도 서비스**
     - 부산시 공공데이터를 활용한 주변 관광지 정보 제공

4. **실시간 인원 확인**
     - 블루투스 기술을 활용한 근거리 팀원 출석 확인 시스템

5. **실시간 위치 정보 공유**
    - Naver Map API, Google Geocoding API 를 활용한 위치 실시간 공유
    - 팀장 위치 추적 기능

6. **행사 일정표 관리**
    - 개인 및 팀별 맞춤 일정 관리 기능
    - 일정 변경 시 실시간 업데이트 및 알림

7. **다국어 번역 서비스**
    - Google Cloud Translation API를 활용한 실시간 다국어 번역 기능
    - 다국적 참가자들의 원활한 의사소통 지원

8. **사용자 경험(UX) 최적화**
    - 직관적이고 사용하기 쉬운 인터페이스 설계
    - 사용자 피드백을 반영한 지속적인 기능 개선

## 기술 스택
- **Design**: Figma, Adobe Illustrator, Adobe Photoshop
- **Frontend**: Flutter, Kotlin, Swift, Android Studio
- **Backend**: Spring Boot, Azure Database for MySQL, Intellij
- **Deploy**: AWS, Docker

## 사용된 API 및 서비스
- Naver Map API
- Google Geocoding API
- Google Cloud Translation API
- Firebase Cloud Messaging (FCM)

## 프로젝트 구조

### ERD (Entity Relationship Diagram)
![ERD](./assets/erd.png)

### API 명세서
API의 상세한 사용법과 엔드포인트에 대한 정보는 아래 링크에서 확인할 수 있습니다:
[API 명세서](https://documenter.getpostman.com/view/34763300/2sAXqzWdvG#intro)

## 팀원 소개

<div align="center">
  <table>
    <tr>
      <td align="center" width="33%">
        <img src="https://avatars.githubusercontent.com/u/55781137?v=4" width="100" height="100"><br>
        <a href="https://github.com/J-1ac">이상준</a><br>
        BE
      </td>
      <td align="center" width="33%">
        <img src="https://avatars.githubusercontent.com/u/31505627?v=4" width="100" height="100"><br>
        <a href="https://github.com/JackAhn">안도현</a><br>
        FE
      </td>
      <td align="center" width="33%">
        <img src="https://avatars.githubusercontent.com/u/182388479?v=4" width="100" height="100"><br>
        <a href="https://github.com/LeeJuAe124">이주애</a><br>
        Design
      </td>
    </tr>
  </table>
</div>

---

## 포트폴리오

프로젝트 발표 자료 및 상세 정보:

<details>
<summary>발표 자료 펼치기</summary>

![발표 자료 1](./assets/presentation_page1.png)
![발표 자료 2](./assets/presentation_page2.png)
![발표 자료 3](./assets/presentation_page3.png)
![발표 자료 4](./assets/presentation_page4.png)
![발표 자료 5](./assets/presentation_page5.png)
![발표 자료 6](./assets/presentation_page6.png)
![발표 자료 7](./assets/presentation_page7.png)
![발표 자료 8](./assets/presentation_page8.png)
![발표 자료 9](./assets/presentation_page9.png)
![발표 자료 10](./assets/presentation_page10.png)
![발표 자료 11](./assets/presentation_page11.png)
![발표 자료 12](./assets/presentation_page12.png)
![발표 자료 13](./assets/presentation_page13.png)
![발표 자료 14](./assets/presentation_page14.png)
</details>

## 라이센스
이 프로젝트는 MIT 라이센스 하에 있습니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.