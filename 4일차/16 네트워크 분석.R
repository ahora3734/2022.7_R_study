#### 1. 데이터 로딩 ####
library(readxl)                        # 엑셀 데이터를 불러올 수 있는 패키지 로딩
library(tidyverse)                     # 데이터 전처리용 패키지
data6 <- read_excel("1일차\\data.xlsx", 6)    # 엑셀 데이터 불러오기


#### 2. 네트워크 분석 ####
install.packages("tidygraph")
library(tidygraph)
install.packages("ggraph")
library(ggraph)
data <- data6 %>% rename(from=1) %>% 
  pivot_longer(-1, names_to = "weight", values_to = "to") %>% 
  na.omit()
#첫번째 있는 것을 from으로 바꾸겠다. 네트워크 분석은 From To 형태
#1순위에 가중치를 둘 수 있음.

as_tbl_graph(data) %>%
  mutate(degree = centrality_degree(mod="in")) %>% 
  arrange(desc(degree)) %>% data.frame()
#mutate: 새로운 변수를 만듦.
#arrange(desc(degree)) 숫자가 큰거에서 작은거 순으로 정렬

as_tbl_graph(data) %>% 
  mutate(degree = centrality_degree(mod="in"), 
         group = group_optimal()) %>% arrange(desc(degree)) %>% 
  ggraph(layout='stress') +
  geom_edge_link(aes(width = weight, edge_colour = weight), 
                 alpha=0.3, edge_width=0.5, 
                 arrow = arrow(length = unit(2, 'mm')), 
                 end_cap = circle(3, 'mm')) + 
  geom_node_point(aes(color=factor(group), size=degree)) +
  geom_node_text(aes(label=name), size=4, repel=TRUE) +
  theme_graph() +
  theme(legend.position='none')
# group = group_optimal()): 그룹을 만들어 준다. 
# geom_edge_link 선을 추가한다.
# width = weight 화살표의 굵기
# alpha: 선의 진하기
#arrow = arrow(length = unit(2, 'mm')): 화살표의 크기
# end_cap: 화살표가 점에 조금 멀어지게
#geom_node_point(aes / 이쁘게 만들어 줌 (color=factor(group) / 그룹별 색, size=degree / 노드의 중심성이 높으면 원을 크게

#repel=TRUE 글자끼리 겹치지 않게 해준다.

#### 가. 설문지 활용 전처리 ####
#### 가. 구글 설문지 활용 ####
data6 %>% 
  mutate(함께=paste0(순위1, ", ", 순위2, ", ", 순위3)) %>% 
  select(이름, 함께) %>% 
  separate(함께, into=c("순위1", "순위2", "순위3"), sep=", ")


#### 나. 가중치 ####
#1순위 3점주고 2순위 2점주고 1순위 1점 준다.
data %>% 
  mutate(weight=str_sub(weight, 3, 3)) %>% 
  mutate(weight=as.numeric(weight)) %>% 
  mutate(weight=ifelse(weight==1, 3, 
                       ifelse(weight==3, 1, 2))) %>% 
  as_tbl_graph() %>%         
  mutate(degree = centrality_degree(mod="in", weights=weight),
         group = group_optimal()) %>% 
  arrange(desc(degree)) %>% 
  ggraph(layout='stress') +
  geom_edge_link(aes(width = weight, edge_colour = weight), 
                 alpha=0.3, edge_width=0.5, 
                 arrow = arrow(length = unit(2, 'mm')), 
                 end_cap = circle(3, 'mm')) + 
  geom_node_point(aes(color=factor(group), size=degree)) +
  geom_node_text(aes(label=name), size=4, repel=TRUE) +
  theme_graph() +
  theme(legend.position='none')
