
# Gourmet

사람들과 의견을 공유하고 원하는 레시피를 작성하고 원하는 레시피를 찾아서 요리를 해볼 수 있는 앱

## 앱 기능

- 레시피 둘러보기 / 작성하기
- 커뮤니티 둘러보기 / 의견 작성하기
- 댓글작성
- 레시피 재료 결제하기

## 프로젝트 세팅

- ios  16.0+
- 기간 09/16 ~ 09/31
- 인원: 1명

## 기술 스택

- UIKit
- MVVM, RXSwift
- Alamofire, SnapKit
- iamport

## 앱 화면

| 화면 1 | 화면 2 | 화면 3 | 화면 4|
| --- | --- | --- | --- |
| <img src="https://github.com/user-attachments/assets/b6d631c6-9686-4974-9b09-fa4fe913e463" width="300" height="400"> | <img src="https://github.com/user-attachments/assets/abe77e65-fee7-42c7-9606-be4d2f6a46e7" width="300" height="400"> | <img src="https://github.com/user-attachments/assets/b28a267e-daeb-4cf4-8278-a15d89bf23d6" width="300" height="400"> | <img src="https://github.com/user-attachments/assets/e3b9a16f-20ec-41d6-9197-64ee1459fde1" width="300" height="400"> |

### 작동영상
| 화면 1 |
| --- |
| <img src="https://github.com/user-attachments/assets/feea623b-a75d-4a5d-a5ee-f33c428827fd" width="300" height="500"> |



## 세부사항

- Router 패턴 사용
- **Routerable** 프로토콜로 Router들의 통일성을 부여 및 Alamofire의 **URLRequestConvertible**을 채택하여 각 Router의 URL 요청객체를 동일한 방식으로 생성하도록 작성
```swift
protocol RouterAble: URLRequestConvertible {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var port: Int? { get }
    var body: Data? { get }
    var query: [URLQueryItem] { get }
    var url: URL? { get }
    var headers: HTTPHeaders { get }
    var method: HTTPMethod { get }
}

```
- View와 ViewModel 생성에 있어 프로토콜로 모든 View와 ViewModel이 동일한 구조를 가지도록 **BaseViewProtocol**과 **ViewModelProtocol**를 작성
- CollectionView에 이용하는 Section의 경우 섹션별 레이아웃 및 UI 설정을 하나의 enum타입으로 관리함으로써, 화면을 구성하는 다양한 섹션을 쉽게 추가, 수정, 제거할 수 있는 구조를 제공
