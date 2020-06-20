// class Promise{
//     constructor(callback) {
//         callback(this.resolve)
//     }
//     status = "Pending"
//     _tasks=[]
//     then = (callback)=>{
//         this._tasks.push(callback)
//     }
//     resolve = (value)=>{
//         this.status = "Resolved"
//         this._tasks.forEach(fun=>fun(value))
//         return this
//     }
// }
//
// let p = new Promise((resolve)=>{
//     setTimeout(()=>{
//         console.log("in promise")
//         resolve("Value from promise")
//     },4000)
// }).then((v)=>{
//     console.log("value comes from promise "+ v)
//     return "Hui"
// })
// callback hell

function outer(fun) {
    setTimeout(()=>{
        console.log("OuterFunction")
        fun()
    },3000)
}

outer(()=>{
    setTimeout(()=>{
        console.log("FirstInner")
        function second() {
            setTimeout(()=>{
                console.log("SecondInner")
                function third() {
                    setTimeout(()=>console.log("ThirdInner"),3000)
                }
                third()
            },3000)
        }
        second()
    },3000)
})
