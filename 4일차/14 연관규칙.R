#### 1. 데이터 로딩 ####
library(readxl)                        # 엑셀 데이터를 불러올 수 있는 패키지 로딩
library(tidyverse)                     # 데이터 전처리용 패키지
data1 <- read_excel("1일차\\data.xlsx", 1)    # 엑셀 데이터 불러오기


#### 2. 연관규칙 ####
install.packages("arules")
library(arules)                        # 연관규칙 분석 패키지

#### 가. typeA ####
# 행렬 형태로 된 데이터
data1 %>% 
  select(친구:혼자) %>%                # 1과 0으로 된 데이터만 선택
  as.matrix() %>%                      # 행렬 데이터 형태로 바꾸기
  as("transactions") %>%               # sparse format으로 변경    
  apriori(list(supp=0.2, conf=0.5, minlen=2)) %>%  # 연관규칙 찾기, supp=0.2이상, conf=0.5이상만 분석하겠다.
  sort(by="lift") %>%                  # lift 순으로 정렬
  inspect()                            # 연관규칙 결과 출력
# support : lhs와 rhs 모두 선택한 비율(82/335)
# confidence : lhs를 선택한 사람 중에 rhs까지 선택한 비율
# lift : 1보다 크면 양의 관계

data1 %>%
  select(친구:혼자) %>%
  lm(친구~., .) %>% #선형회귀 종속변수~독립변수
  summary()
# 친구를 종속변수로 한 회귀분석과 차이나는 이유는? (강사) 회귀분석은 윈인과 결과다. 

#### 나. typeB ####
# 결측치가 있는 데이터 
data1 %>% 
  select(grep("맛", names(.))) %>% 
  rename_all(~str_sub(., 1, -2)) %>% 
  mutate_all(~ifelse(is.na(.), 0, 1)) %>%  #is.na(.) 결측치가 있으면 True -> 0, 없으면 Fauls -> 1
  as.matrix() %>%                      # 행렬 데이터 형태로 바꾸기
  as("transactions") %>%               # sparse format으로 변경    
  apriori(list(supp=0.6, conf=0.8, minlen=2)) %>%  # 연관규칙 찾기
  sort(by="lift") %>%                  # lift 순으로 정렬 // 클수록 추천했을 때 만족도가 높음.
  inspect()                            # 연관규칙 결과 출력


#### 다. TypeC ####
# 도서대출 시스템과 같은 형식의 데이터
(data <- data1 %>% 
   select(친구:혼자) %>% 
   mutate(이름=make.names(1:nrow(.)), .before=1) %>% 
   pivot_longer(-이름) %>% 
   filter(value==1) %>% 
   select(-value))

library(reshape2)

data %>% 
  dcast(이름~name) %>% #와이드 타입으로 바꿀 수 있음.
  select(-1) %>%  #1열(이름) 삭제
  mutate_all(~ifelse(is.na(.), 0, 1)) %>%          # 강제로 0과 1로 만들어 주기
  as.matrix() %>%                                  # 행렬 데이터 형태로 바꾸기
  as("transactions") %>%                           # sparse format으로 변경    
  apriori(list(supp=0.2, conf=0.5, minlen=2)) %>%  # 연관규칙 찾기
  sort(by="lift") %>%                              # lift 순으로 정렬
  inspect()                                        # 연관규칙 결과 출력

