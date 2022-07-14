#### 1. 데이터 로딩 ####
library(readxl)                        # 엑셀 데이터를 불러올 수 있는 패키지 로딩
library(tidyverse)                     # 데이터 전처리용 패키지
data5 <- read_excel("1일차\\data.xlsx", 5)    # 엑셀 데이터 불러오기


#### 2. 연관규칙 ####
install.packages("ahpsurvey")
library(ahpsurvey)                     # 의사결정 분석 패키지

atts <- c("도서관경영", "정보자원", "시설환경", "인적자원", "도서관서비스")

data5 %>% 
  ahp.mat(atts=atts, negconvert = T) %>% 
  ahp.aggpref(atts, method = "arithmetic")

data5 %>% 
  ahp.mat(atts = atts, negconvert = TRUE) %>% 
  ahp.indpref(atts, method = "eigen") %>% 
  #gather(도서관경영:도서관서비스, key = "var", value = "pref") %>%
  pivot_longer(everything()) %>%
  ggplot(aes(x = name, y = value)) + 
  geom_violin(alpha = 0.6, width = 0.8, color = "transparent", fill = "gray") + #회색음영 항아리(빈도가 많은 곳이 볼록)
  geom_jitter(alpha = 0.6, height = 0, width = 0.1) + #(한점에 여러점이 모여 있어)jitter가 점을 좌우로 흩어 주는 역할을 함.
  geom_boxplot(alpha = 0, width = 0.3, color = "#808080") 

