import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
    name: "search",
    pure: false
})
export class SearchPipe implements PipeTransform{
    transform(value : any, arg: string){
        if(value){
            return value.filter((item)=> item.name.startsWith(arg))
        }
    }
}
