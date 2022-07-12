#### 1. 데이터 로딩 ####
library(readxl)                     # 엑셀 데이터를 불러올 수 있는 패키지 로딩
data1 <- read_excel("data.xlsx")    # 엑셀 데이터 불러오기


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

data2 <- read_excel("data.xlsx", 2)
data2 %>% pivot_longer(2:3) %>% ggwithinstats(name, value)
