[![Gitter](https://badges.gitter.im/smu405/s.svg)](https://gitter.im/smu405/s?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

# Smart Contract

* 최종수정일 20190305화

## 교과목 개요

## 주별 강의 (--는 범위에서 제외한다는 뜻)

주 | 일자 | 내용 | 실제
-----|-----|-----|-----
주 1 |  3.06수 | 블록체인 소개
주 2 |  3.13수 | 스마트컨트랙
주 3 |  3.20수 | Geth
주 4 |  3.27수 |
주 5 |  4.03수 | Simple Project
주 6 |  4.10수 |
주 7 |  4.17수 | Solidity
주 8 |  4.24수 | 중간 시험 midterm 
주 9 |  5.01수 |
주 10 |  5.08수 |
주 11 |  5.15수 |
주 12 |  5.22수 |
주 13 |  5.29수 |
주 14 |  6.05수 |
주 15 |  6.12수 | 기말시험


## 과제
* 빅데이터 과제를 제안하여, 완성한다 (댓글 또는 열린데이터 사용)
* 다음 일정에 따라 ecampus에 제출한다.

주 | 기한 | 내용
-----|-----|-----
1차 | 7주 토요일 | 문제를 정하고, 어떤 데이터를 사용할 것인지. ecampus에 제출
2차 | 보강주 월요일 | 전체 제출. 문서출력 및 ecampus에 소스코드 제출. 15주차 발표.

## 참고문헌


* old toc
    * ethereum.ipynb
        * e1: intro
        * e2: network
        * e3: account
        * e4: transaction
        * e5: smart contract
        * e6: interaction with geth
        * e7: interaction with json rpc
        * e8: interaction with nodejs
        * e9: event

    * solidity.ipynb
        * s1: solidity and nodejs

    * ethWeb.ipynb
        * w1: cases on web
            * 웹에서 컴파일하고, 잔고 모니터링
            * coin
            * ballot
    * ethplus.ipynb
        * topics
            * DApp
            * Rpi

## shell scripts

* project directory
    * node libraries in node_modules

* geth network
    * set up network
    ```
    sh _geth.sh
    ```

* compile solidity
    * read a source file from src
    * writing json file to src (abiDefinition, address)
    ```
    node _compile.js
    ```

* run solidity
    * creating an instance from json file
    ```
    node _run.js
    ```
* run javascript
    * _balance.js: watch an account if balance is changed

    ```
    node src/_balance.js
    ```

## end


