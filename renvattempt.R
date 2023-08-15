library(praise)
praise()

library(emo)
emo::ji("cat")
emo::ji("eyes")
emo::ji("skull")
emo::ji("squirrel")
praise()
emo::ji("cat")

renv::init("praise")
renv::status("praise")
renv::snapshot("praise")

square<-function(x){x^2}
square2<-function(x){
	squareval<-x*x
	return(squareval)
}
square(2)
square(2)

raise <- function(x,power=2) {x^power}
raise(2,2)
raise(3,5)
raise(3,)
raise(3,3)
