#### 1. 데이터 로딩 ####
install.packages("readxl")
library(readxl)                     # 엑셀 데이터를 불러올 수 있는 패키지 로딩
data1 <- read_excel("1일차\\data.xlsx")    # 엑셀 데이터 불러오기


#### 2. 기술통계 ####
install.packages("dlookr")
library(dlookr)                     # 기술통계 쉽게 내주는 패키지 로딩
diagnose_category(data1)            # 범주형 데이터 통계
describe(data1)                     # 연속형 데이터 통계

table(data1$성별, data1$연령)


#### 3. 파이프 연산자 ####
install.packages("tidyverse")
library(tidyverse)                  # 데이터 전처리를 쉽게 할 수 있는 패키지 로딩

data1 %>% 
  diagnose_category()               # 범주형 데이터 통계 내는 방법


#### 4. select ####
data1 %>% 
  select(친구:혼자) %>%
  describe() %>%
  write.csv("기술통계_연속형.csv")

data1 %>% 
  select(성별, 연령) %>%
  table()


#### 5. filter ####
data1 %>% 
  filter(성별=="남") %>% 
  select(친구:혼자) %>% 
  describe()

# data1 %>% 
#   select(친구:혼자) %>% 
#   filter(성별=="남") %>% 
#   describe()                
# 이 경우는 에러남 select하면서 성별이 없기 때문에 filter 할 수 없어서 아래와 같이 해야함.

data1 %>% 
  select(성별, 친구:혼자) %>% 
  filter(성별=="남") %>% 
  describe()

data1 %>% 
  select(성별, 친구:혼자) %>% 
  filter(성별=="남") %>% 
  describe() %>% 
  data.frame() # 데이터 전체를 보고 싶을 때 기본은 tibble(상위 몇개만 보여줌)

data1 %>% 
  filter(연령=="20~22") %>% 
  select(친구:혼자) %>% 
  describe()


#### 6. mutate ####
data1 %>% 
  select(친구:혼자) %>% 
  mutate(합계=rowSums(.)) 

data1 %>% 
  select(친구:혼자) %>% 
  mutate(평균=rowMeans(.))  

data1 %>% 
  select(친구:혼자) %>% 
  mutate(합계=rowSums(.), 평균=rowMeans(.)) 

data1 %>% 
  select(친구:혼자) %>% 
  mutate(친구=as.factor(친구)) %>%    #친구를 factor로 만들어 줘라
  diagnose_category()

data1 %>% 
  select(친구:혼자) %>% 
  mutate(친구=as.factor(친구)) %>%    #친구를 factor로 만들어 줘라
  mutate(친구=as.character(친구)) %>% #친구를 chr로 만들어 줘라
  mutate(친구=as.integer(친구))       #친구를 integer로 만들어 줘라  
  diagnose_category()


#### 7. group_by ####
data1 %>% 
  select(성별, 모두랑맛:모두랑재방문) %>% 
  group_by(성별) %>% 
  describe()
  
data1 %>% 
  select(성별, 구분, 모두랑맛:모두랑재방문) %>% 
  group_by(성별, 구분) %>% 
  describe()
