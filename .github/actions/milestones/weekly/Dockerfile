FROM alpine
RUN apk update && apk add ruby ruby-dev ruby-etc build-base && gem install json && gem install bigdecimal && gem install octokit -v 4.15.0 && gem install activesupport 
COPY . /
ENTRYPOINT ["/weekly.rb"]