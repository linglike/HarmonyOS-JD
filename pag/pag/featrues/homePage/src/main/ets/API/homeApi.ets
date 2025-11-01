import {MyhttpRequest} from "common"
import { http } from "@kit.NetworkKit"
import { listData} from "../viewModel/viewModel"
export function listDatea():Promise<listData[]>{
  return MyhttpRequest("/users",http.RequestMethod.GET,"")
}