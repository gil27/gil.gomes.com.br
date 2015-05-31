---
layout: post
title: "Unless Or Negative Expressions On Conditionals"
modified: 2014-09-23 20:21:08 -0300
tags: [Ruby, Ruby on Rails]
comments: true
image:
  feature: picjumbo.png
  credit: Viktor Hanacek
  creditlink: https://picjumbo.com/download/?d=HNCK5393.jpg
share: true
---

Today we're going through at how we deal with negative conditionals. Let's dive into the next topic at Ezequiel's [blog post](http://edelpero.svbtle.com/most-common-mistakes-on-legacy-rails-apps?utm_source=gilgomes.com.br)

## Unless Or Negative Expressions On Conditionals

It's amazing our ability to tell histories by negative conditionals.

> "If I do not have enough money then I can't buy a car";
  "If a house is not for sale, do not show the sale";
  "If it is not a goal, do not change the score";
  "If you dont have good grades you will not go to that party".

It's natural for humans being tell histories like that, believe me you do that all the time. In terms of code, this is not cool at all. It is difficult to read, it inverts a basic if-else case and turn it into hell.
You should not think about negative conditionals when you are working. I've been coding on a code base which has more than 500 hundred lines of code, in a single method. Take a look inside those methods and you will come across if-else's inherited in a multi-level way, and they have a lot of negative expression and conditionals.
It is difficult to understand, test, and breath :smiley:

Let's take a look at this example:

{% highlight ruby %}
  def dummy_method
    if !has_enough_money? && not_under_eighteen
      return 'you need more money'
    elsif has_enough_money? && !not_under_eighteen
      return 'you must be an adult to buy a car'
    elsif has_enough_money? && not_under_eighteen
      return 'success'
    end
    # ...
  end

  def validations &block
    #...
    unless processed
      process
    else
      already_processed if !something_has_changed?
    end
    # ...
  end
{% endhighlight %}


This is a dummy example, but very common. This is not just a beginner privilege, a lot of senior programmers do that, and that's ok. As I told before, it is normal to do that "mistake". In fact, it is not a mistake, but it makes the code difficult to read and more difficult to understand.

Let's think about this code a little bit. How can we improve it to be more readble? Martin Fowler in this [refactoring series](http://www.refactoring.com/catalog/reverseConditional.html) said:

> #### Motivation
> Often conditionals can be phrased in way that makes them hard to read. This is particularly the case when they have a not in front of them. If the conditional only has a "then" clause and no "else" clause, this is reasonable. However if the conditional has both clauses, then you might as well reverse the conditional.

> #### Mechanics
> - Remove negative from conditional.
> - Switch clauses
> - Compile and test.

So let's improve our code with this change, moving the conditionals and add another three methods `is_adult?`, `under_eighteen?` and `nothing_has_changed?`. These new methods can be just a wrapper containing the negative conditionals for us.

{% highlight ruby %}
  def dummy_method
    if adult? && has_enough_money?
      return 'success'
    else
      return 'you must be an adult to buy a car' if under_eighteen?
      return 'you need more money'
    end
  end

  def validations &block
    if processed && nothing_has_changed?
      already_processed 
    else
      process
    end
  end
{% endhighlight %}


Easier to read, and to identify where we need to improve from here to made our code simple to read and be more understable.

I'm not the best giving examples, but I'm pretty sure you get my point here. This simple change can improve and facilitate our lives in a level that I am not able to describe here.

If you do not got anything till here, keep this in mind: It always is going to be easier to read the code if the conditions are not negative. Keep this in mind and you'll go further and deeper on your code base without stress.

And remember, always leave things better than you found them!

See you soon.
