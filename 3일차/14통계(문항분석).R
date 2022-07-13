#### 1. 데이터 로딩 ####
library(readxl)
data4 <- read_excel("1일차\\data.xlsx", 4)

#### 2. 문항분석 ####
install.packages("ShinyItemAnalysis")
library(ShinyItemAnalysis)

DDplot(data4) 
#난이도(빨강): 1이면 모두 다 맞췄다.
#변별도(파랑): 가로로 선이 있는데 0.2 이보다 낮은 6번 문항은 변별되지 않는 문항임.
#0.3보통 0.4이상 매우 높음, 국가고시 변별도 pdf 0.3 넘기 힘들다.

ItemAnalysis(data4)
# RIR 문항간 상관 ULI 변별도

DDplot(data4, k=5, l=3, u=5) # 상위권과 최상위권을 구분하는가 분석 방법
#K 그룹을 몇개로 나눌 것이냐? 기본값은 k = 3(상중하), l=1, u=3
#l 3번째 그룹을 하위권으로 두고  5번째 그룹은 상위권으로 지정