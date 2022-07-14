#### 1. 데이터 로딩 ####
library(readxl)                        # 엑셀 데이터를 불러올 수 있는 패키지 로딩
library(tidyverse)
install.packages("janitor")
library(janitor)
data4 <- read_excel("1일차\\data.xlsx", 4)    # 엑셀 데이터 불러오기


#### 2. 문항분석 ####
library(ShinyItemAnalysis)

DDplot(data4)                          # 상, 중, 하 3 그룹 중 상(3)과 하(1) 사이의 변별도
DDplot(data4, k=3, l=1, u=3)           # 상, 중, 하 3 그룹 중 상(3)과 하(1) 사이의 변별도
DDplot(data4, k=5, l=3, u=5)           # 최상, 중상, 중, 중하, 최하 5그룹으로 나누었을 때 최상(5)과 중(3) 사이의 변별도
DDplot(data4, k=5, l=4, u=5)           # 최상, 중상, 중, 중하, 최하 5그룹으로 나누었을 때 최상(5)과 중상(4) 사이의 변별도

ItemAnalysis(data4)                    # 상, 중, 하 3 그룹 중 상(3)과 하(1) 사이의 변별도
ItemAnalysis(data4, k=3, l=1, u=3)     # 상, 중, 하 3 그룹 중 상(3)과 하(1) 사이의 변별도
ItemAnalysis(data4, k=3, l=3, u=5)     # 최상, 중상, 중, 중하, 최하 5그룹으로 나누었을 때 최상(5)과 중(3) 사이의 변별도
ItemAnalysis(data4, k=5, l=4, u=5)     # 최상, 중상, 중, 중하, 최하 5그룹으로 나누었을 때 최상(5)과 중상(4) 사이의 변별도


#### 3. 나이스 자료 ####
rdata <- read_excel("4일차\\미적분 1회 공유용.xls", skip=5) %>%   # 5번째 줄까지는 패스
  remove_empty() %>%                                           # 데이터가 없는 열 삭제
  select(-번호, -grep("...", names(.)), 서답형점수) %>%        # 번호 및 ...이 포함된 열 삭제 
  rename_at(vars(1:(ncol(.)-1)), ~paste0("문항", .))           # 문항이라는 글자 붙이기

score <- rdata %>% select(-서답형점수) %>% slice(2) %>%        # 문항당 배점 선택
  pivot_longer(everything()) %>% pull(value)                   # 배점만 저장

item <- rdata %>% slice(-c(1:2)) %>% na.omit()                 # 정답 및 배점, 결측치 삭제

for(coln in 1:(ncol(item)-1)){                                 # .은 문항당 배점 입력 나머지는 0
  item <- item %>% mutate(!!paste0("문항", coln) := ifelse(get(paste0("문항", coln))==".", score[coln], 0))
}

item <- item %>% mutate_all(~as.numeric(.))                    # 문자를 실수 타입으로 변경

DDplot(item)                                                   # 난이도순으로 정렬
DDplot(item) + scale_x_discrete(limits=colnames(item))         # 문항순으로 정렬
