---
layout: post
title: "Using Meaningless Names"
modified: 2014-09-06 11:46:08 -0300
tags: [Ruby, Ruby on Rails]
image:
  feature: abstract-4.jpg
  credit: dargadgetz
  creditlink: http://www.dargadgetz.com/ios-7-abstract-wallpaper-pack-for-iphone-5-and-ipod-touch-retina/
share: true
---

Today we're going through at the importance of  naming things. Let's dive into the next topic at Ezequiel's [blog post](http://edelpero.svbtle.com/most-common-mistakes-on-legacy-rails-apps?utm_source=gilgomes.com.br)

## Using Meaningless Names

Code reading, method/variable naming is difficult. It is an art that separates men from boys.

A friend once tweeted:

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p><a
href="https://twitter.com/gil27">@gil27</a> &quot;There are only two hard things
in Computer Science: cache invalidation and naming things.&quot;</p>&mdash; João
Maia (@jvrmaia) <a
href="https://twitter.com/jvrmaia/status/496358026446921728">August 4,
2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

When you are working on a project that you are the only developer, it is easy to use nameless variables: a, b, c, x, y, z. Those are terrible variables names.

Look at this example:
{% highlight ruby %}
class StudentHelper
  def monitor(a, b, c)
    if a.senior(c) && a.is_monitor(c) && !b.senior(c)
     link_to 'ask for help', ask_path(a)
    end
  end
end
{% endhighlight %}

This methods checks if a student 'A' is monitor for a course that student 'B' is doing. If so, display a link to contact student 'A'. Take a look again to the code, is it easy to read? Is it clear? I don't think so. How can we improve this code just renaming things?

The first step is renaming the helper method name and its variables
{% highlight ruby %}
class StudentHelper
  def monitor?(student_a, student_b, course)
    if sutend_a.senior?(course) && student_a.monitor?(course) && !student_b.senior?(course)
       link_to 'ask for help', ask_path(student_a)
    end
  end
end
{% endhighlight %}

For keep renaming let's extract a method:

{% highlight ruby %}
class StudentHelper
  def monitor?(student_a, student_b, course)
    if student_a.monitor_at?(course) && student_b.coursing?(course)
      link_to 'ask for help', ask_path(student_a)
    end
  end
end

class Student
  def monitor_at?(course)
    self.senior?(course) && self.monitor?(course)
  end

  def coursing?(course)
    !self.senior?(course)
  end
end
{% endhighlight %}

We can keep renaming all day long. But it will became a big refactoring. For today it is fine to stop here. We just made simple to kids becomes men. Probably the final result will be something like that:

{% highlight ruby %}
class StudentHelper
  def monitor?(student_a, student_b, course)
    if student_a.can_be_monitor_of(student_b, course)
      link_to 'ask for help', ask_path(student_a)
    end
  end

  or
  
  def monitor?(student_a, student_b, course)
    if student_a.monitor_of(course) && student_b.coursing?(course)
      link_to 'ask for help', ask_path(student_a)
    end
  end
end
{% endhighlight %}

The final message is: "Always be assertive". If your method alerts you about lunch time than name it in a way that is easy to know its purpose.
Today we saw that rename things properly can improve our code readability and makes our life easier.
I think we got the right mindset here, in the next few posts we going to see another little things that can improve our life :smiley:

And remember, always leave things better than you found them!

See you soon.
