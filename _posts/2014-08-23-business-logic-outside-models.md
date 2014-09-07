---
layout: post
title: "Business Logic Outside Models"
modified: 2014-08-23 16:20:18 -0300
tags: [ruby on rails, ruby]
comments: true
image:
  feature: abstract-11.jpg
  credit: dargadgetz
  creditlink: http://www.dargadgetz.com/ios-7-abstract-wallpaper-pack-for-iphone-5-and-ipod-touch-retina/
share: true
---

Ezequiel Delpero recentily blogged about the [Most Common Mistakes On Legacy Rails Apps](http://edelpero.svbtle.com/most-common-mistakes-on-legacy-rails-apps?utm_source=gilgomes.com.br). He made a list of common bad practices, and how to improve the code or avoid those bad practices. In the next few posts I am going to dive into each topic of his list.

## Business Logic Outside Models

Let's start by remember briefly what the 'M' of MVC is:

> M = Model. It represents the business logic and holds the knowledge of the application.
> V = View. It represents the view ot the application, is how the model is represented to the final user.
> C = Controller. It is a link between the Model and View.

So, as we can see, the Model layer holds the business logic of the application. It’s his responsibility to handle with the logic.

There are some free candies that I like in this MVC approach:

1. It's easy to test the logic;
2. If necessary, it's easier to change the core language, because we don't have to care if our controllers or views has the old logic;
3. We don't get married with any framework; and
4. Specially if you are running a Ruby on Rails application, the test suite for the business layer, runs faster than never.

The following code is real. Extracted from a real world controller and it is up running in production. For some legal reasons I've changed the metaphor of it, but kept the logic.
eg: car becomes airplane
{: .notice}

We have an Hangar with a bunch of robots. Broken robots are flagged as an unavailable.
Each unavailable has types and subtypes.

The above code was extracted from the `TechnicalUnavailabilitiesController`

{% highlight ruby %}

def new
  @unavailability = Unavailability.new

  @robots = Robot.joins_data.where_data.order("[robots].prefix")
  @robots_map = Robot.joins_data.where_data
  @hang     = Hangar.select('hangar.id, hangar.name, hangar.prefix').find(:all)
  
  if params[:han_g].to_i != 0
    @han = true
    @hangar = Hangar.select('hangar.id, hangar.name, hangar.prefix').find(params[:han_g])
  else
    @han = false
    @hangar = Hangar.select('hangar.id, hangar.name, hangar.prefix').find(:all)
  end
  @roles = User.find(current_user.id).roles.first.name
  @unavailability_types = UnavailabilityType.where("id = 11 or id = 5 or id = 7")
  
  respond_to do |format|
    format.html # new.html.erb
    format.xml  { render :xml => @unavailability }
  end
end

{% endhighlight %}

We have a lot of work to do here, right? This is the first time ever that I saw that creepy code, I've just grabbed it from the source repository and changed the name of some models and variables names. This method has a lot of bad smells, but I'm going to focus in the business logic.

So, the first step is understand what the code are doing.

We instantiate a new Unavailability, found some robots and ordered them by prefix, than the first strange thing happens, we bring the robots again, but this time without ordering them. I don't know why the programmer did that, but let's keep looking at the code.
The next step is bring all Hangars to the game and store them into `@hang` var. Now we check if the `params[:han_g].to_i` is different of zero, it means that we passed a id trough params. and we know what hangar we'll work with, but if the `params[:han_g].to_i` is zero we bring all the hangars with `@hangar` variable.

Oh, Gosh. I can do at least 3 more articles with this method.

Back to work. Now our method picks the current user first role and find arbitrary Unavailability Types based on some ids. And our method finishes with a respond to.

## Extracting logic from controller

I don't care how crazy our logic is. The first step is extract the logic out of our controller. When I say **extract** is not **re-hacktoring** or even **re-factoring**, is just extract.

{% highlight ruby %}
class Robot
  scope :by_prefix, -> { order("[robots].prefix") }
  # ...
end
{% endhighlight %}

{% highlight ruby %}
class Hangar
  scope :basic_fields, -> { select('hangars.id, hangars.name, hangars.prefix') }

  def self.find_hangar(id)
    id = id.to_i
    if id != 0
      Hangar.basic_fields.find(id)
    else
      Hangar.basic_fields.all
    end
  end
  # ...
end
{% endhighlight %}

{% highlight ruby %}
class UnavailabilityType
  scope :special_case, -> { where("id = 11 or id = 5 or id = 7") }
  # ...
end
{% endhighlight %}

Our controller's method now looks like this:

{% highlight ruby %}
def new
  @unavailability = Unavailability.new
  @robots = Robot.joins_data.where_data.by_prefix
  @robots_map = Robot.joins_data.where_data
  @hang = Hangar.basic_fields.all
  @hangar = Hangar.find_hangar(params[:way_p])
  @han = @hangar.is_a?(Array)

  @roles = User.find(current_user.id).roles.first.name
  @unavailability_types = UnavailabilityType.special_case
  
  respond_to do |format|
    format.html # new.html.erb
    format.xml  { render :xml => @unavailability }
  end
end
{% endhighlight %}

I've just extracted all the crazy logic out of the controller. In this point I still don't care how crazy this code was/is, because now I can focus on fix things like: 

{% highlight ruby %}
@roles = User.find(current_user.id).roles.first.name
{% endhighlight %}

Now we are allowed to work over models logic and don't need to care about controllers anymore, I rotate my efforts to make my business logic more clean, code more efficient and testable.

But this is another article. This method has a lot of problems, but for today we can celebrate our work, this was a big step for a cleaner and better software.

And remember, always leave things better than you found them!

See you soon.
