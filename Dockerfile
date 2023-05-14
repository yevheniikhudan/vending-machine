FROM ruby:3.2.2
WORKDIR /vending-machine
COPY . /vending-machine
RUN bundle install --without development test
CMD ["ruby", "./run.rb"]