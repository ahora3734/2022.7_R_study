#### 1. 데이터 로딩 ####
install.packages("pacman")
pacman::p_load(readxl,                                        # 엑셀 데이터 로딩
               caret, ranger, tidymodels, DALEX, modelStudio, # 머신러닝
               tidyverse)                                     # 데이터 전처리

rdata <- read_excel("1일차\\data.xlsx", 7)


#### 2. 일반적인 방법 ####
#### 가. 데이터 전처리 ####
rdata <- rdata %>% mutate(심장병=as.factor(심장병))  # 범주형은 factor로


#### 나. 데이터 나누기 ####
splits <- initial_split(rdata, prop=0.8, strata=심장병) # 층화표본추출
train <- training(splits)                               # 훈련 데이터
test <- testing(splits)                                 # 테스트 데이터


#### 다. 모델 만들기 ####
fit_rf <- train(심장병~., train, method="ranger" ,trControl = trainControl(classProbs=TRUE)) # randomforest
#fit_rf <- train(심장병~., train, method="lm")  회귀분석?
#fit_rf <- train(심장병~., train, method="rlm")  로지스틱회귀분석?
#fit_rf <- train(심장병~., train, method="glmnet")  리지?와 라소?를 합친거?


#### 라. 예측결과 확인하기 ####
predict(fit_rf, test) %>% 
  confusionMatrix(test$심장병, positive="심장병")       # 혼돈 행렬
predict(fit_rf, test, type="prob")                      # 확률 확인

fit_glm <- train(심장병~., train, method="glm")
predict(fit_glm, test) %>% 
  confusionMatrix(test$심장병, positive="심장병") 
predict(fit_glm, test)                      # 확률 확인
predict(fit_glm, test, type="prob")                      # 확률 확인

summary(fit_glm)
