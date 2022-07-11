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

data1 %>% diagnose_category()               # 범주형 데이터 통계 내는 방법


#### 4. select ####
data1 %>% 
  select(친구:혼자) %>%
  describe() %>%
  write.csv("기술통계_연속형.csv")

data1 %>% 
  select(성별, 연령) %>%
  table()

print("2022.07.12")