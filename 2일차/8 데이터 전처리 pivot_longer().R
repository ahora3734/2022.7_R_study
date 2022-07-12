#### 1. 데이터 로딩 ####
library(readxl)                     # 엑셀 데이터를 불러올 수 있는 패키지 로딩
data1 <- read_excel("data.xlsx")    # 엑셀 데이터 불러오기


#### 2. 기술통계 ####
library(dlookr)                     # 기술통계 쉽게 내주는 패키지 로딩
diagnose_category(data1)            # 범주형 데이터 통계
describe(data1)                     # 연속형 데이터 통계

table(data1$성별, data1$연령)


#### 3. 파이프 연산자 ####
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
  mutate(친구=as.factor(친구)) %>% 
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

data1 %>% 
  select(성별, 구분, 모두랑맛:모두랑재방문) %>% 
  group_by(성별, 구분) %>% 
  describe() %>%
  select(구분, 성별, described_variables, mean, sd)

#### 8. pivot_longer ####
install.packages("ggpubr")
library(ggpubr)
data1 %>% 
  select(모두랑맛:모두랑재방문) %>% 
  pivot_longer(1:5) %>%  #세로로 길게 (longer) 데이터를 변경
  ggbarplot(x="name", y="value", add="mean", fill="name", 
            legend="none", label=T, lab.nb.digits = 1) # 그래프를 그림 
  #fill="name" X축으로 사용하는 'name' 별로 색을 다르게 해라
  #legend(범례), label=T (true), lab.nb.digits = 1 소숫점 첫째자리까지
  #R 스튜디오에서는 창 크기 조절할때 그래프 크기도 자동으로 조절됨.
  
?ggbarplot #파라미터 확인할 수 있음.

data1 %>% 
  select(모두랑맛:모두랑재방문) %>% 
  pivot_longer(1:5) %>%  #세로로 길게 (longer) 데이터를 변경
  ggbarplot(x="name", y="value", add="mean") 

data1 %>% 
  select(모두랑맛:모두랑재방문) %>% 
  pivot_longer(모두랑맛:모두랑재방문) %>%  #(1:5)와 같음
  ggbarplot(x="name", y="value", add="mean") 
  
data1 %>% 
  select(구분, 모두랑맛:모두랑재방문) %>% 
  pivot_longer(-구분) %>%  #구분을 뺀 나머지(모두랑맛:모두랑재방문)를 longer
  ggbarplot(x="name", y="value", add="mean", fill="구분", label=T, lab.nb.digits = 1,
            position=position_dodge2())

data1 %>% 
  select(구분, 모두랑맛:모두랑재방문) %>% 
  pivot_longer(-구분) %>%  
  ggbarplot(x="name", y="value", add="mean", fill="구분", label=T, lab.nb.digits = 1)
  #position=position_dodge2()를 빼면..

data1 %>% 
  select(모두랑맛:모두랑재방문) %>% 
  pivot_longer(1:5, names_to="변수") %>% 
  ggbarplot(x="변수", y="value", add="mean", fill="변수",  legend="none", 
  label=T, lab.nb.digits = 1)
