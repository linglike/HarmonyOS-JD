import { Cart } from "./cart"

// Index.ets
@Entry ({routeName:"myCar"})
@Component
export struct shoppingCar {
 build() {
   Column(){
     Cart()
   }
   .width("100%")
   .height("100%")

 }
}