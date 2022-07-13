#### 1. 데이터 로딩 ####
library(dlookr)                     # 기술통계 쉽게 내주는 패키지 로딩
library(tidyverse)                  # 데이터 전처리를 쉽게 할 수 있는 패키지 로딩
                                    # 4 데이터 전처리 참고
library(ggstatsplot)
library(readxl)                     # 엑셀 데이터를 불러올 수 있는 패키지 로딩
data1 <- read_excel("설문_수정.xlsx")    # 엑셀 데이터 불러오기

#### 2. 기술통계 ####
#### 가. 범주형 ####
data1 %>% diagnose_category() #tmestamp, 가 보임 빼보자.

data1 %>% select(-1) %>% diagnose_category() #하고싶은말도 보임 빼보자.

data1 %>% select(-1, -10) %>% diagnose_category()

data1 %>% select(-c(1, 10)) %>% diagnose_category()

data1 %>% diagnose_category(-1, -10) #진연이가 해 본 방법.

data1 %>% 
  select(성별, 학교급) %>% 
  filter(성별 != "기타", 학교급 != "기타") %>%
  table() %>% 
  data.frame() %>% 
  ggpiestats(성별, 학교급, Freq)   
# p=0.000312(3.12e-04) 0.05보다 작으면 통계적으로 유의한 차이가 있다.
# k=2 small(0.1<=v<0.3), Medium(0.3<=V<0.5), large(0.5<=V) : k=두 범주 중 작은 범주의 개수
# k=3 small(0.07<=v<0.2), Medium(0.2<=V<0.35), large(0.35<=V)
# k=4 small(0.06<=v<0.17), Medium(0.17<=V<0.29), large(0.39<=V)


#### 나. 범주형에 따른 연속형 ####
data1 %>% ggbetweenstats(성별, 만족도) #성별에 기타가 있다. 기타를 제거해 보자.

data1 %>% filter(성별!= "기타") %>%
ggbetweenstats(성별, 만족도) #성별에 기타가 있다. 기타를 제거해 보자.
# Cohen’s d : small(0.2<=d< 0.5), Medium(0.5<=d<0.8), Large(0.8<=d)
# 표본수<20이면 Heidge's g가 더 좋고 그룹간의 표준편차가 크게 다르면 class Delta를 사용한다.
# 0.5는 실험집단의 평균이 비교집단보다 표준편차의 0.5배만큼 크다. 이는 비교집단의 약70%는 실험집단의 평균보다 작다.

#### 다. 연속형 ####
data1 %>% describe()


#### 라. 회귀분석 ####
data1 %>%
  select(데이터:학교급) %>%
  lm(만족도~., .) %>% 
  summary()

data1 %>%
  select(데이터:학교급) %>%
  lm(만족도~기대충족, .) %>%  #기대충족만 통계적 유의하니까
  summary()