
- https://rst-it.com/blog/apiary-documentation-rspec-api-doc-generator/  
  Apiary Documentation with RSpec API Doc Generator

```
$ rails new car_api --api
$ cd car_api

edit Gemfile
$ bundle install

$ bundle exec rails generate rspec:install
$ bundle exec rails g model Car name brand year:integer
$ bundle exec rails db:create && bundle exec rails db:migrate

edit app/model/car.rb
edit app/controllers/api/v1/cars_controller.rb
edit config/routes.rb
edit app/serializers/api/v1/car_serializer.rb
edit spec/acceptance_helper.rb
edit spec/acceptance/api/v1/cars_spec.rb

$ bundle exec rake docs:generate

edit doc/api/index.apib
```

api ドキュメントの作成
```
$ npm install -g aglio
$ aglio -i doc/api/index.apib -o doc/api/index.html
```

モックの起動
```
$ npm install -g hariko
$ hariko -f doc/api/index.apib
```

別端末で
```
$ brew install jq
$ curl http://localhost:3000/api/v1/cars | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   110  100   110    0     0  17214      0 --:--:-- --:--:-- --:--:-- 18333
[
  {
    "id": 2,
    "name": "Impeza",
    "brand": "Subaru",
    "year": 2015
  },
  {
    "id": 1,
    "name": "Polo",
    "brand": "Vokswagen",
    "year": 2011
  }
]
```

dredd

```
$ npm install -g dredd
$ dredd init
$ rake db:drop RAILS_ENV=test
$ rake db:migrate RAILS_ENV=test
$ rails s -e test
```

別端末で
```
$ dredd
info: Configuration './dredd.yml' found, ignoring other arguments.
info: Beginning Dredd testing...
pass: POST (201) /api/v1/cars duration: 1321ms
pass: POST (400) /api/v1/cars duration: 86ms
pass: DELETE (204) /api/v1/cars/1 duration: 125ms
pass: GET (200) /api/v1/cars?%271%27,%2710%27 duration: 65ms
complete: 4 passing, 0 failing, 0 errors, 0 skipped, 4 total
complete: Tests took 1668ms
```
