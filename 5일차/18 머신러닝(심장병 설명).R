#### 1. 데이터 로딩 ####
pacman::p_load(readxl,                                        # 엑셀 데이터 로딩
               caret, ranger, tidymodels, DALEX, modelStudio, # 머신러닝
               tidyverse)                                     # 데이터 전처리

rdata <- read_excel("1일차\\data.xlsx", 7)


#### 2. 설명 보기 ####
#### 가. 데이터 전처리 ####
rdata <- rdata %>% mutate(심장병=ifelse(심장병=="심장병", 1, 0))


#### 나. 데이터 나누기 ####
splits <- initial_split(rdata, prop=0.8, strata=심장병)
train <- training(splits)
test <- testing(splits)


#### 다. 모델 만들기 ####
fit_rf <- train(심장병~., train, method="ranger")
#"rf"로 해도 되는데 "ranger"가 좀더 빠름.


#### 라. 결과 확인하기 ####
pred <- predict(fit_rf, test)
ifelse(pred>0.5, 1, 0) %>% as.factor() %>% 
  confusionMatrix(as.factor(test$심장병), positive="1")


#### 마. 설명 보기 ####
explainer_rf <- explain(
  model = fit_rf,
  data = test,
  y = test$심장병,
  label = "caret rf"
)

test[1:5, ] %>% pull(심장병) #[1:5(행), 열]

modelStudio(explainer_rf, test[1:5, ]) #많이 집어넣을 수록[1:5, ] 오래걸림.

# set.seed(1234)
# variable_importance(explainer_rf) %>% plot()
# 
# predict_parts(explainer = explainer_rf,
#               new_observation = test,
#               type = "break_down") %>% plot()
