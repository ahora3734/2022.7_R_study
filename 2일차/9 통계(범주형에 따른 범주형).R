#### 1. 데이터 로딩 ####
library(readxl)                     # 엑셀 데이터를 불러올 수 있는 패키지 로딩
data1 <- read_excel("1일차\\data.xlsx")    # 엑셀 데이터 불러오기


#### 2. 통계 분석 ####
#### 가. 범주형에 따른 범주형 ####
install.packages("ggstatsplot")
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

data1 %>% 
  select(성별, 구분) %>% 
  table() %>% 
  data.frame() %>% 
  ggpiestats(성별, 구분, Freq)

data1 %>% 
  select(성별, 구분) %>% 
  table() %>% 
  data.frame() %>% 
  ggpiestats(구분, 성별, Freq)