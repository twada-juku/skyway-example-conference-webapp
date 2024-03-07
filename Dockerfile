# from https://docs.docker.jp/compose/django.html
FROM python:3.9 as dev
ENV PYTHONUNBUFFERED 1
RUN mkdir /stacksPy
WORKDIR /stacksPy
ADD requirements.txt /stacksPy/
RUN pip install -r requirements.txt
ADD . /stacksPy/

CMD ["flask", "--app", "stacks", "run", "--debugger", "--host=0.0.0.0", "--reload"]
# For Migration
#CMD ["alembic", "upgrade", "head"]


# 本番環境用ステージ
FROM gcr.io/distroless/python3 as prod

ENV PYTHONUNBUFFERED 1

# ローカル開発との競合を避けるため WORKDIR は場所を変え /app ではなく /opt/app/ を使う
WORKDIR /opt/app/

# dev ステージからインストール済みライブラリだけ取得する
COPY --from=dev /usr/local/lib/python3.9/site-packages /root/.local/lib/python3.9/site-packages
# Flask サーバの起動に使用する gunicorn コマンドも dev ステージからコピーする
COPY --from=dev /usr/local/bin/gunicorn /opt/app/gunicorn

# ローカルのファイルシステムからプロダクトコードのみをコピーする
COPY stacks /opt/app/stacks

# distroless はシェルが無いので設定ファイルで CloudRun から渡される PORT 環境変数を展開する
CMD ["gunicorn", "--config", "/opt/app/stacks/gunicorn.conf.py"]