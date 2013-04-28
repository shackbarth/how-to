Getting used to asynchronous programming with callbacks isn't easy if you're
coming from a more classical language where the control flow runs from
top to bottom. This short set of tutorials should 
help get you from zero to a sense of how we use callbacks to communicate
between our enyo view layer and our backbone model layer. 

Don't just read this code. Plug it into [jsfiddle](http://jsfiddle.net) and
play with it until you're comfortable with what's going on. If you're at
all insecure with any of this and have some free time on your hands, I would
recommend trying to recreate each bit by memory on jsfiddle, using the 
Chrome debugger to help iron out your bugs.

By the end you should understand that callbacks are not magical.

So let's start with some classical code that should be totally familiar.

```javascript
    var returnFoo = function () {
      return "foo";
    };

    var printItOut = function (value) {
      alert(value);
    };

    printItOut(returnFoo());
```

No problem, right? One thing that's worth noting here, which you probably
took for granted, is that the return function doesn't have to care about
what is done to its content, and the print function doesn't have to care
what the content is. The functionality is neatly encapsulated. We'll want
to keep that same practice when we use callbacks as well.

Let's redo this using callbacks. You probably already know that in javascript, 
functions are first-class objects that can be passed in as parameters just
like any other object, and that's what we do here.


    var sendFooToCallback = function (thisIsThePrintFunction) {
      // the parameter is a function! We can call it like a function.
      thisIsThePrintFunction("foo");
    };

    var printItOut = function (value) {
      alert(value);
    };

    sendFooToCallback(printItOut);


Of course, for the encapsulation reason I mentioned earlier, we don't want
to presuppose what the person that calls sendFooToCallback wants to do with
that callback, so let's just name the callback "callback". 


    var sendFooToCallback = function (callback) {
      callback("foo");
    };

    var printItOut = function (value) {
      alert(value);
    };

    sendFooToCallback(printItOut);


We still have the neat encapsulation where 
one function is agnostic to the content and the other function is agnostic
to what's done to the content. We don't want to know in the sendFooToCallback
function what the callback does, just like we don't want to know in returnFoo
what gets done to the return value.

Look also how the last lines are different. For one, we've inverted the
order of the functions. But also see that the parens of the internal function
are missing in the second code snippet. That's because in the first
snippet we're calling returnFoo() and passing the *return value* of that
function to printItOut. In the second snippet, we're passing the function
itself as the parameter. No parens.

Okay, so why would we ever want to write code like this? Why not just use a 
return value, like before? Well, consider if the value "foo" is actually
on the server, and the sendFooToCallback function has an asynchronous 
call to the server, which we'll mimic by a simple timeout.


    var sendContentToCallback = function (callback) {
      setTimeout(function() { 
        // this will take a second...
        callback("foo");
      }, 1000);
    };

    var printItOut = function (value) {
      alert(value);
    };

    sendContentToCallback(printItOut);


If you're coming from a classical background you might be inclined to try
to capture some sort of return value from sendFooToCallback, like


    var sendContentToCallback = function (callback) {
      setTimeout(function() { 
        callback("foo");
      }, 1000);
      return "Sorry! I don't know about foo yet.";
    };

    var printItOut = function (value) {
      alert(value);
    };

    var isThisFoo = sendContentToCallback(printItOut);
    alert(isThisFoo);


This is hopeless. sendFooToCallback just isn't going to know about foo by the
time it returns. That return value is typically going to be useless, which is
why we need to use callbacks in the first place.

Okay, so let's start working towards our enyo/backbone implementation, by
putting these functions in objects that can talk to each other.


    var myModel = {
      fetchContent: function (callback) {
        setTimeout(function() { 
          callback("foo");
        }, 1000);
      }
    };

    var myView = {
      model: myModel,
      run: function () {
        var printItOut = function (value) {
          alert(value);
        };
        this.model.fetchContent(printItOut);
      }
    };

    myView.run();


Now we're object-oriented. Still, nothing magical here! One thing to 
notice is the the model has no idea about the existance of the view.
That's true to our own implementation, in which our backbone layer
is not aware of enyo in the slightest. Okay, let's rename
and tweak some of this stuff to get even closer to our implementation.


    var myModel = {
      attributes: {},
      save: function (key, value, options) {
        var that = this;

        // let's start storing these values in the attributes object,
        // more or less like backbone does.
        this.attributes[key] = value;

        setTimeout(function() { 
          // myModel assumes that options is an object, and that 
          // options.success is a function, and that THAT'S where the view
          // is putting the callback.
          options.success(that.attributes);
        }, 1000);
      }
    };

    var myView = {
      value: myModel,
      run: function () {
        var printItOut = function (value) {
          alert("Model contents are now " + JSON.stringify(value));
        };
        this.value.save("baz", "foo", {success: printItOut});
      }
    };

    myView.run();


This is now starting to look like our code. It's important that you can 
get from the previous snippet to this snippet, so try it yourself on 
jsfiddle until you can get every step of the way.

Another thing I should mention is that the first parameter that myModel
sends to setTimeout is *another, different* callback, that happens not 
to do anything except for to call the first callback. In our stack you'll 
frequently see
(callbacks inside of callbacks inside of callbacks inside of callbacks)[https://github.com/shackbarth/xtuple/blob/5ea3d6fd0951156c0f14c987753890b6f8794e51/node-datasource/test/mocha/lib/crud.js#L255-L259]
. 
It's just the only way to do things sequentially in an asynchronous environment.

Okay, let's actually use enyo now. If you're in jsfiddle, you'll need to
select the framework to import in the upper-left dropdown. Note that while
the view object now really is enyo, the model object here is not the
*actual* [backbone source](http://backbonejs.org/docs/backbone.html#section-56). 
It just mimics the backbone model behavior enough to be illustrative.


    var myModel = {
      attributes: {},
      save: function (key, value, options) {
        var that = this;

        // let's start storing these values in the attributes object,
        // more or less like backbone does.
        this.attributes[key] = value;

        setTimeout(function() { 
          // myModel assumes that options is an object, and that 
          // options.success is a function, and that THAT'S where the view
          // is putting the callback.
          options.success(that.attributes);
        }, 1000);
      }
    };

    enyo.kind({
      name: "FooTest",
      published: {
        value: null
      },
      components: [{
        kind: "onyx.Button",
        content: "Set Baz",
        ontap: "run"
      }],
      run: function () {
        var printItOut = function (value) {
          alert("Model contents are now " + JSON.stringify(value));
        };
        this.getValue().save("baz", "foo", {success: printItOut});
      }
    });

    var fooTest = new FooTest();
    fooTest.setValue(myModel);
    fooTest.renderInto(document.body);
   

See? Easy. For the sake of completeness, I should add that there is an
alternate ([some](./assets/zombie_john.jpg) would say "preferable") way for
enyo and backbone to communicate, which is by using event triggers. Again,
the way I'm going to mock up how the model operates is more simplified than 
the [actual source](http://backbonejs.org/docs/backbone.html#section-15)
but it should be illustrative of how using event triggers is conceptually
possible without any magic.


    var myModel = {
      attributes: {},
      on: function (name, callback) {
        // simplification: only mimics the on('all', callback) invocation

        // just shove this callback function somewhere.
        this._eventCallback = callback;
      },
      save: function (key, value, options) {
        var that = this;
        
        this.attributes[key] = value;

        setTimeout(function() { 

          // call the trigger if there is one
          if(that._eventCallback) {
            that._eventCallback(that);
          }

          // call the callback if there is one
          if(options && options.success) {
            options.success(key + " has been successfully set to " + value);
          }
        }, 1000);
      }
    };

    enyo.kind({
      name: "FooTest",
      published: {
        value: null
      },
      components: [{
        kind: "onyx.Button",
        content: "Set Baz",
        ontap: "run"
      }],
      printItOut: function (value) {
        alert("Model contents are now " + JSON.stringify(value));
      },
      run: function () {
        this.getValue().save("baz", "foo");
      },
      valueChanged: function() {
        this.getValue().on('all', this.printItOut);
      }
    });

   var fooTest = new FooTest();
   fooTest.setValue(myModel);
   fooTest.renderInto(document.body);


That's it. Hopefully you'll find it helpful to understand 
*how this stuff is even possible* before you try to grapple with the 
actual implementation details of our stack, which is obviously more thorough
and therefore more daunting to learn. Being able to get this far by your own
hand is an important complement to studying the code that everyone else 
has written.
