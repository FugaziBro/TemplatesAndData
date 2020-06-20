let _x = function(callback,initial = this[0]){
    let elems = this
    if(arguments[1]!==undefined)
    for(let elem of elems){
        let acc = callback(initial, elem)
        initial = acc
    }
    else {
        let [, ...newElems] = elems
        for (let elem of newElems) {
            let acc = callback(initial, elem)
            initial = acc
        }
    }
    return initial
}


Array.prototype.reducer = _x

console.log([1,2,3,5,5].reducer((start,elem)=>{
    return ++start
}))


console.log([1,2,3,5,5].reduce((start,elem)=>{
    return ++start
}))

