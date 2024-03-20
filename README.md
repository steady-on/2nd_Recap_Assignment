# MyWishList

사고 싶은 상품을 검색하고, 찜목록에 저!장!

## 미리보기

| ![SearchProduct](https://github.com/steady-on/2nd_Recap_Assignment/assets/73203944/d27b27bc-2181-425c-a9af-f010cb5efbc0) | ![SearchResults](https://github.com/steady-on/2nd_Recap_Assignment/assets/73203944/2f19778e-5a10-442f-b59f-a318ca2708a4) | ![WebPage](https://github.com/steady-on/2nd_Recap_Assignment/assets/73203944/a131aee5-4e46-4df4-82cd-ad58416ab9f3) | ![WishList](https://github.com/steady-on/2nd_Recap_Assignment/assets/73203944/85c27664-c709-475a-887d-eee8881ac9b8) | ![Alert](https://github.com/steady-on/2nd_Recap_Assignment/assets/73203944/9ea7045a-ceca-42da-91c9-53504b78df1e) |
| ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |

## 기능 소개

1. 네이버 쇼핑 API를 활용한 상품 검색 기능
2. 상품의 이미지, 상품명, 판매점명, 가격 표시 및 정렬조건 설정 기능 구현
3. prefetchItemsAt 메서드를 활용한 페이지네이션 기능
4. WebKit을 활용하여 상품 상세보기 기능
5. Realm을 활용한 찜목록 저장
6. 다크모드 지원

## 작업 기간 및 인원

- 2023.09.07 ~ 2023.09.11(5일)
- 1인 개발

## 기술 스택

- Deployment Target: iOS 13.0
- 개발 환경: Swift 5, Xcode 14
- 프레임워크: UIKit; codebase UI
- 라이브러리: KingFisher, Realm
- 아키텍처: MVC
- 그 외 활용 기술: Codable, WebKit, NWPathMonitor, UICollectionViewDelegate & DataSource, DataSourcePrefetching

## 핵심 구현 요소

- Realm을 활용하여 상품 찜하기/찜취소 기능 구현
- 찜목록 내 상품 실시간 검색 기능 구현
- prefetchItemsAt 메서드를 활용한 페이지네이션 기능 구현
- WebKit을 활용한 제품 상세페이지 기능
- NWPathMonitor를 활용하여 기기의 네트워크 통신 상태에 대한 반응형 UI 구현

## 트러블 슈팅

### 1. 이미지에 대한 메모리 최적화

- 문제: 스크롤 시에 셀 재사용으로 인해 동일한 이미지가 계속 나타나고, prefetching으로 스크롤이 이어질 때 이미지가 느리게 나타남
- 해결: prepareForReuse 메서드를 override하여 재사용되는 셀의 상태를 초기화 해주었고, KingFisher의 ImagePrefetcher를 활용하여 prefetching된 데이터의 이미지를 미리 가져와서 화면에 표시하기 전에 캐시해두도록 했습니다. 이를 통해 셀의 내용에 맞는 정확한 이미지를 빠르게 표시할 수 있어 메모리 사용 최적화도 달성할 수 있었습니다.

### 2. ViewController의 생명주기를 활용한 실시간 데이터 동기화

- 문제: 상품 검색 탭과 찜목록 탭에서 동일한 상품을 띄우고 찜상태를 변경 시 Realm에 없는 데이터로 앱이 비정상적으로 종료됨
- 해결: 탭 변경 시 View의 Appear관련 메서드가 호출되는 특성에 따라 viewWillAppear에서 해당 item이 Realm 테이블에 존재하는지 확인 후 하트버튼의 모양에 반영되도록 로직을 추가하였습니다. 추가로 CollectionView의 경우에는 DataStorage에서 검색결과와 Realm 데이터를 모두 가지고 있으면서 비교하여 찜상태를 공유하도록 하고, DataStorage에 있는 데이터를 DataSource에 넣어주어 간단히 reloadData 메서드를 호출해주는 것만으로 동기화 된 데이터가 보여지도록 구현해주었습니다.
