## Mocks and stubs

Create a mock object with no predefined methods

```ruby
  m = double('movie')  
```

Replace an existing 'rating' method on 'm', or define a new one if none exists, and return a canned response.
You can use expect or allow - allow means the method may or may not be called, e.g. 'if called'.

```ruby
    allow(m).to receive(:rating).and_return('R')
    
    # create a mock/double that returns a value - combines previous two steps
    m = double('movie', rating: 'R') 
    
    # pass in one, or more args with a specific value
    allow(m).to receive(:rating).with('PG', 'G').and_return(['PG', 'G'])
    
    # pass in one or more generic args
    allow(m).to receive(:find).with(anything(), anything())
    
    # check that a obj is called with a hash(or hash like) that includes the the key 'title' and value 'Milk'
    allow(m).to receive(find).with(hash_including title: 'Milk')
    
    # check that an object ic called with no args
    allow(m).to receive(find).with(no_args()) 
```

Force a particular value to be returned

````ruby
    allow(Movie).to receive(:find).and_return(@fake_movie)
````

Create a POST request, replace 'post' with 'get', 'put', or 'delete'. http verb takes two args, route and a params hash.

```ruby
    post '/movies/create', {title: 'Star Wars', rating: 'PG'}
```

Check that a controller action renders a particular template/view 

```ruby
    expect(response).to render_template('show')
```

Check that a controller action redirects to a particular view

```ruby
    expect(response).to redirect_to(controller: 'movies', action: 'new')
```



