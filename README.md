[![Gitter](https://badges.gitter.im/smu405e/2021.svg)](https://gitter.im/smu405e/2021?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge) [![Join the chat at https://gitter.im/smu405/j12](https://badges.gitter.im/smu405/j12.svg)](https://gitter.im/smu405/j12?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# 블록체인 프로그래밍 

* 최종수정일 20210301MON

## 교과목 개요
비트코인에서 블록체인은 데이터저장소로 활용되었다. 최근에 블록체인은 프로그램을 할 수 있는 플랫폼으로 발전하고 있다. 블록체인의 안전성을 강화하는 필수적인
합의알고리즘, 암호화, 머클트리 등을 이해하고, 스마트콘트랙, 분산앱 DApp을 구현해 본다.
- geth 네트워크 실습
- 계정, 트랜잭션, 암호화, 마이닝, 합의 이해
- Solidity, 스마트콘트랙 개발
- nodejs (또는 python)으로 구현하는 분산앱 dApp 개발

## 주별 강의 (--는 범위에서 제외한다는 뜻)

주 | 일자 | 내용 | 실제
-----|-----|-----|-----
주 1 |  3.02 | 블록체인 소개
주 2 |  3.09 | 스마트컨트랙
주 3 |  3.16 | Geth
주 4 |  3.23 | Geth
주 5 |  3.30 | Simple Project
주 6 |  4.06 |
주 7 |  4.13 | Solidity
주 8 |  4.20 | 중간 시험 midterm 
주 9 |  4.27 |
주 10 |  5.4 |
주 11 |  5.11 |
주 12 |  5.18 | web3.py
주 13 |  5.25 | coin, 투표등 dApp
주 14 |  6.01 |
주 15 |  6.08 | 기말시험


## 과제
* dApp 과제를 제안하여, 완성한다
* 다음 일정에 따라 ecampus에 제출한다.

주 | 기한 | 내용
-----|-----|-----
1차 | 7주 토요일 | 아이디어를 정해서 초기 버전을 ecampus에 제출
2차 | 보강주 월요일 | 전체 제출. 문서출력 및 ecampus에 소스코드 제출. 14주차 발표.

## 참고문헌


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

