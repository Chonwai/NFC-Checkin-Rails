# 使用 Ruby 3.1.0 作為基礎鏡像
FROM ruby:3.1.0

# 安裝必要的依賴
RUN apt-get update -qq && apt-get install -y postgresql-client

# 設置工作目錄
WORKDIR /app

# 安裝 Rails 依賴
COPY Gemfile Gemfile.lock ./
RUN bundle install

# 複製應用程序代碼
COPY . .

# 設置環境變量
# ENV RAILS_ENV=production
# ENV RAILS_SERVE_STATIC_FILES=true

# 預編譯資產 (如果您的應用需要)
# RUN bundle exec rails assets:precompile

# 設置入口點
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# 暴露端口
EXPOSE 3000

# 啟動 Rails 服務器
CMD ["rails", "server", "-b", "0.0.0.0"]