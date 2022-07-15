#### 1. 데이터 로딩 ####
pacman::p_load(readxl,                                        # 엑셀 데이터 로딩
               foreign,                                       # spss 데이터 로딩
               caret, ranger, gbm, tidymodels, DALEX, modelStudio, # 머신러닝
               tidyverse)                                     # 데이터 전처리

rdata <- read.spss("5일차\\kyrbs2021.sav", reencode = "utf-8", to.data.frame = T)


#### 2. 설명 보기 ####
#### 가. 데이터 전처리 ####
data <- rdata %>% select(M_STR:M_SUI_CON) %>% 
  mutate(M_SUI_CON=ifelse(M_SUI_CON==2, 1, 0)) %>%  #M_SUI_CON==2 자살을 생각한 적이 있다.
  na.omit()

data <- data %>% select(-grep("MM", names(.))) #MM 주중에 일어난 시간(7시 30분의)의 분. 분석에서 제외하자.


#### 나. 데이터 나누기 ####
splits <- initial_split(data, prop=0.8, strata=M_SUI_CON)
train <- training(splits)
test <- testing(splits)


#### 다. 모델 만들기 ####
fit_gbm <- train(M_SUI_CON~., train, method="gbm", verbose=F)
# verbose=F // T 라면 데이터를 랜덤하게 여러개를 만들어 분석, 정규분포를 만족하지 않았던 것이 만족하게 됨.
#fit_gbm <- train(M_SUI_CON~., train, method="ranger", verbose=F) 는 실행안됨.


#### 라. 결과 확인하기 ####
pred <- predict(fit_gbm, test)
ifelse(pred>0.5, 1, 0) %>% as.factor() %>% 
  confusionMatrix(as.factor(test$M_SUI_CON), positive="1")
# (터미널)Accuracy: 
# (터미널)Kappa:
# (터미널)Sensitivity:
# (터미널)Pos pred Value:
# (터미널)Neg pred Value: 자살안할거야 라고 예측했을때 자살 안한 확률


#### 마. 설명 보기 ####
explainer_rf <- explain(
  model = fit_gbm,
  data = test,
  y = test$M_SUI_CON, #종속변수: M_SUI_CON, 심장병, 잎갯수
  label = "caret gbm"
)

test[1:5, ] %>% pull(M_SUI_CON)

modelStudio(explainer_rf, test[4, ])

set.seed(1234)
variable_importance(explainer_rf) %>% plot()

predict_parts(explainer = explainer_rf,
              new_observation = test[2,],
              type = "break_down") %>% plot()


