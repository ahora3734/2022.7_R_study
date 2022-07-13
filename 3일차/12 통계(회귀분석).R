#### 1. 데이터 로딩 ####
library(readxl)                     # 엑셀 데이터를 불러올 수 있는 패키지 로딩
data1 <- read_excel("1일차\\data.xlsx")    # 엑셀 데이터 불러오기


#### 2. 통계 분석 ####
#### 가. 범주형에 따른 범주형 ####
library(ggstatsplot)
data1 %>% 
  select(성별, 연령) %>% 
  table() %>% 
  data.frame() %>% 
  ggpiestats(성별, 연령, Freq)   
# p=0.000312(3.12e-04) 0.05보다 작으면 통계적으로 유의한 차이가 있다.
# k=2 small(0.1<=v<0.3), Medium(0.3<=V<0.5), large(0.5<=V) : k=두 범주 중 작은 범주의 개수
# k=3 small(0.07<=v<0.2), Medium(0.2<=V<0.35), large(0.35<=V)
# k=4 small(0.06<=v<0.17), Medium(0.17<=V<0.29), large(0.39<=V)


#### 나. 범주형에 따른 연속형 ####
data1 %>% ggbetweenstats(성별, 선호도)
# Cohen’s d : small(0.2<=d< 0.5), Medium(0.5<=d<0.8), Large(0.8<=d)
# 표본수<20이면 Heidge's g가 더 좋고 그룹간의 표준편차가 크게 다르면 class Delta를 사용한다.
# 0.5는 실험집단의 평균이 비교집단보다 표준편차의 0.5배만큼 크다. 이는 비교집단의 약70%는 실험집단의 평균보다 작다.

data1 %>% ggbetweenstats(연령, 선호도)
# omegasq : small(0.01<=omega<0.25), medium(0.25<=omega<0.4), large(0.4<=omega)
# 에타제곱은 표본수가 작거나 독립변수의 그룹이 많은 경우 편향되는 경향이 있어서 이를 보완한 오메가제곱이 더 좋다.
# (사후분석)20~22와 27~ 사이의 p값이 통계적으로 유의하여 그래프에 나오지만. 통계적 유의하지 않은 그룹간의 p값은 나오지 않음.
# (사후문석)R에서도 사후분석 방법을 선택하여 수행할 수 있다(강사님). 
# 그러나 지금 실행된 사후검사방법이 무엇인지 설명 없었으며, 강사님은 R에서 자동으로 구해주는 사후검사를 신뢰하는 의견임.

data2 <- read_excel("1일차\\data.xlsx", 2) #2번째 sheet
data2 %>% pivot_longer(2:3) %>% ggwithinstats(name, value)

#### 다. 연속형에 따른 연속형 ####
#모두랑맛, 모두랑재방문 -> 맛있는것과 재방문 사이의 관련성
data1 %>% ggscatterstats(모두랑맛, 모두랑재방문)

#상관관계 분석  correlation analysis
library(tidyverse)                  
# 데이터 전처리를 쉽게 할 수 있는 패키지 로딩
# select 사용하려면 필요
data1 %>% select(모두랑맛:모두랑재방문) %>% ggcorrmat()

#청년다방에 재방문에 영향을 주는 가장 높은 요인은?
data1 %>% select(청년다방맛:청년다방재방문) %>% ggcorrmat()
#ggcorrmat()는 결측값도 알아서 처리해줌.

#보통 시중 교재에서는 상관을 cor()
data1 %>% select(청년다방맛:청년다방재방문) %>%
 na.omit() %>% cor() #na.omit() 결측값이 있으면 사례를 제거함

#### 라. 회귀분석 ####
data1 %>%
  select(성별, 선호도) %>%
  lm(선호도~성별, .) %>% #선형회귀 종속변수~독립변수
  summary()
  #(결과) "성별여"라고 나옴. 남자를 통제하였기 때문에
  #(해석)남자에 비해 여자들은~~ Estimate(계수)가 양수이면 (떡볶이를) 더 좋아함. 
  #Adjusted R-Squared: 설명력, 1이면 100%, 성별을 가지고 선호도를 맞추는데 9.2% 맞출 수 있다.

data1 %>%
  select(연령, 선호도) %>%
  lm(선호도~연령, .) %>% #선형회귀 종속변수~독립변수
  summary()

data1 %>%
  select(모두랑맛:모두랑재방문) %>%
  lm(모두랑재방문~모두랑맛+모두랑가격+모두랑친절+모두랑청결, .) %>% #선형회귀 종속변수~독립변수
  summary()

data1 %>%
  select(모두랑맛:모두랑재방문) %>%
  lm(모두랑재방문~., .) %>% #첫번째 . 은 종속변수 빼고 나머지가 다 독립변수라는 뜻
  summary()
