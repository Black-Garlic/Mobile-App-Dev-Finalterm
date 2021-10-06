// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'product.dart';

class ProductsRepository {
  ProductsRepository();

  static List<Product> allProducts = <Product> [
    const Product(
      id: 0,
      isFeatured: false,
      star: 1,
      name: '라비드 아틀란 호텔',
      address: '부산 해운대구 중동 1392-8',
      phone: '010-1234-1234',
      desc: '라비드 아틀란 호텔은 총 436객실로 부산 해운대 구남로 중심에 위치하여 볼거리, 먹거리, 놀거리가 모두 어우러진 특별함을 경험하실 수 있으며, 해운대 해변으로부터 도보 2분 거리에 위치하고 있습니다. 코발트색의 아름다운 바다와 하늘, 자연과 도시가 어우러진 경이로운 풍경이 파노라마처럼 펼쳐지는 특별한 여유와 낭만을 제공 합니다',
    ),
    const Product(
      id: 1,
      isFeatured: false,
      star: 2,
      name: '이비스 앰배서더 호텔',
      address: '부산 해운대구 우동 651-1',
      phone: '010-2345-2345',
      desc: '해운대 해수욕장 앞에 위치하여 휴가를 즐기는 여행객이 높은 만족도를 느낄 수 있습니다. 바다전망 객실에서 소중한 사람과 아름다운 해운대의 경치를 추억하실 수 있습니다',
    ),
    const Product(
      id: 2,
      isFeatured: false,
      star: 1,
      name: '골든 튤립 호텔',
      address: '부산 해운대구 중동 1153-8',
      phone: '010-0011-1100',
      desc: '라비드 아틀란 호텔은 총 436객실로 부산 해운대 구남로 중심에 위치하여 볼거리, 먹거리, 놀거리가 모두 어우러진 특별함을 경험하실 수 있으며, 해운대 해변으로부터 도보 2분 거리에 위치하고 있습니다. 코발트색의 아름다운 바다와 하늘, 자연과 도시가 어우러진 경이로운 풍경이 파노라마처럼 펼쳐지는 특별한 여유와 낭만을 제공 합니다',
    ),
    const Product(
      id: 3,
      isFeatured: false,
      star: 3,
      name: '마리안느 호텔',
      address: '부산 해운대구 중동 1400-24',
      phone: '010-1100-1223',
      desc: '부산을 방문하는 관광객들은 물론 비즈니스 고객들에게 휴식과 편리함을 제공하고 있습니다. 해운대 해수욕장과 인접하여 객실과 옥외 스카이라운지에서 해운대 바다를 바라보며 휴식을 취할 수 있습니다',
    ),
    const Product(
      id: 4,
      isFeatured: false,
      star: 1,
      name: '하운드 호텔',
      address: '부산 해운대구 우동 637-9',
      phone: '010-1111-1111',
      desc: '2021년 3월 발리풍 컨셉 신축 오픈',
    ),
    const Product(
      id: 5,
      isFeatured: false,
      star: 3,
      name: '베니키아 프리미어 호텔',
      address: '부산 해운대구 중동 1398-23',
      phone: '010-0000-1234',
      desc: '해운대해수욕장까지 도보로 약 5분 거리에 위치하고 있어 아쿠아리움, 달맞이길 등으로의 이동이 매우 편리합니다. 전 객실에서 따뜻한 천연 해수 온천수가 공급되며, 투숙고객 대상 무료로 이용할 수 있는 해수탕, 버블탕 등의 사우나 시설이 있습니다',
    ),
  ];

  List<Product> loadProducts() {
    return allProducts;
  }

  Product loadProduct(int index) {
    return allProducts[index];
  }

  List<Product> loadFavoriteProducts() {
    return allProducts.where((Product p) {
      return p.isFeatured == true;
    }).toList();
  }

  void changeProduct(int index, bool favorite) {
    Product newProduct = Product(
      id: allProducts[index].id,
      isFeatured: favorite,
      star: allProducts[index].star,
      name: allProducts[index].name,
      address: allProducts[index].address,
      phone: allProducts[index].phone,
      desc: allProducts[index].desc,
    );

    allProducts[index] = newProduct;
  }
}
