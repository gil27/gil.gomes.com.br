---
layout: post
title: "Using Logic Inside The Views"
modified: 2014-08-30 19:25:06 -0300
tags: [Ruby, Ruby on Rails]
image:
  feature: abstract-3.jpg
  credit: dargadgetz
  creditlink: http://www.dargadgetz.com/ios-7-abstract-wallpaper-pack-for-iphone-5-and-ipod-touch-retina/
share: true
---

The next topic at Ezequiel's [blog post](http://edelpero.svbtle.com/most-common-mistakes-on-legacy-rails-apps?utm_source=gilgomes.com.br) is about logic inside the view layer. We will going through a common problem that can cause a lot of headaches to the maintainers.

## Using Logic Inside The Views

Today I will bring to you guys another example from the real world. I am going to keep using the repository from the [previous post](http://www.gilgomes.com.br/business-logic-outside-models/).

The day was friday and a co-worker asked me for help. Our customer was needing to edit a field that was uneditable, but just admin users will be able to do that. She was trying to figure out what the hell her code does not worked.

The original code:
{% highlight html %}
<div class="row">
  <%= f.select :unitweight_id, @unitweights.map {|r| [r.name,r.id]}, { :disabled => true} %>
</div>
{% endhighlight %}

Her editor had the following code:
{% highlight html %}
<div class="row">
  <% if current_user.roles.first.id == 1 %>
    <%= f.select :unitweight_id, @unitweights.map {|r| [r.name,r.id]}, { :disabled => true} %>
  <% else %>
    <%= f.select :unitweight_id, @unitweights.map {|r| [r.name,r.id]} %>
  <% end %>
</div>
{% endhighlight %}

What's the problem of doing that? It is just a simple "if/else" case. My co worker said: When the user's first role isn't equals 1 the select still disabled.

After some minutes we discovered a javascript at the bottom of the file:

{% highlight javascript %}
<script type="text/javascript">
<% if @editing %>
  document.getElementById("aircraft_unitweight_id").disabled = true;
<% end %>
</script>
{% endhighlight %}

That's not cool at all folks. Don't do that!

Ok, we just remove the javascript and the problem was gone. But wait, what if we changed the database and the admin role id change? what if we needed to add another user that will be able to edit that field? But do not think in that right now.

I am talking about a big software, a complex one. Doing that kind of thing in our views can be very, very dangerous. Our first change is to remove the javascript. So, now our code looks like this:

{% highlight html %}
<div class="row">
  <%= f.select :unitweight_id, @unitweights.map {|r| [r.name, r.id]}, {}, :disabled => (!current_user.roles.first.id.eql? 1) %>
</div>
{% endhighlight %}

Our code still works, but we can do better. We can use a helper method:

{% highlight html %}
<div class="row">
  <%= f.select :unitweight_id, @unitweights.map {|r| [r.name, r.id]}, {}, :disabled => (disable?) %>
</div>
{% endhighlight %}

{% highlight ruby %}
# Helper class
def disable?
  !current_user.is_admin?
end

# User class
def is_admin?
  roles.ids.first.eql? 1
end
{% endhighlight %}

With this simple change we doesn't need to touch our view anymore. It's not a fancy and sophisticated solution, but it's a beginning. We can use things like presenters and decorators to solve these problems of logic inside views. But let's keep simple for now. With simple things like that we solved the customer problem, and we are able to work outside the view in the logic part of our software.

we can celebrate our work, this was another big step for a cleaner and better software.

And remember, always leave things better than you found them!

See you soon.
