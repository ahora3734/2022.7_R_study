#### 1. 데이터 로딩 ####
pacman::p_load(readxl,                                        # 엑셀 데이터 로딩
               caret, ranger, tidymodels, DALEX, modelStudio, # 머신러닝
               tidyverse)                                     # 데이터 전처리

rdata <- read_excel("1일차\\data.xlsx", 8)


#### 2. 설명 보기 ####
#### 가. 데이터 전처리 ####
rdata <- rdata %>% mutate(잎개수=ifelse(잎개수=="3", 1, 0))


#### 나. 데이터 나누기 ####
splits <- initial_split(rdata, prop=0.8, strata=잎개수)
train <- training(splits)
test <- testing(splits)


#### 다. 모델 만들기 ####
fit_rf <- train(잎개수~., train, method="ranger")


#### 라. 결과 확인하기 ####
pred <- predict(fit_rf, test)
ifelse(pred>0.5, 1, 0) %>% as.factor() %>% 
  confusionMatrix(as.factor(test$잎개수), positive="1")


#### 마. 설명 보기 ####
explainer_rf <- explain(
  model = fit_rf,
  data = test,
  y = test$잎개수,
  label = "caret rf"
)

test[1:5, ] %>% pull(잎개수)

modelStudio(explainer_rf, test[1:5, ])

# set.seed(1234)
# variable_importance(explainer_rf) %>% plot()
# 
# predict_parts(explainer = explainer_rf,
#               new_observation = test,
#               type = "break_down") %>% plot()
