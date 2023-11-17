# 영화소개 앱
# 🚠Project

## 🦉About

영화에 대한 설명, 장르, 제목, 평점 등을 알려주는 어플리케이션

## 🛠️사용 기술

- Flutter, Android
- Open API

## ✈핵심 기능

- Open API로 영화의 인스턴스를 만들어서 앱에 적용시켰다.
- FutureBuilder로 비동기 작업의 결과물을 가져오게 했다.

## 🤔후기

텍스트가 너무 길어 화면을 넘어가는것에 대해 오류가 종종 있었다. 지금 생각해보면 Text위젯에 속성을 이용해서 아래 속성을 넣으면 쉽게 해결될 수 있을것이다.

Text(
내 텍스트,
overflow: TextOverflow.ellipsis,
maxLines: 내가 설정하는 줄 수,
)
