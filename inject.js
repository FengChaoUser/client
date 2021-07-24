if (require('electron').remote) {
    window.hello = function(){
      console.log('world')
    }
 }