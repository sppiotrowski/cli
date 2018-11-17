# docker
docker system prune  # clear all
<container_id> = docker create <image> <cmd>
docker start [-a] <container_id>
docker logs <container_id>
docker ps [--all]
docker (stop|kill) # stop - docker will kill after 10s
docker exec -it <container_id> <cmd>  # -it -> interactive & tty
docker exec -it <container_id> sh     # access shell - C+D to exit
# docker building
docker build <dir>  # dir - dir with Dockerfile (build context)
docker build . -t sppiotrowski/green:latest  # tagging
docker commit -c 'CMD ["<CMD>"]' <running container id>  # create image manualy instead of using Dockerfile
# docker-compose
vim docker-compose.yml
docker-compose up --build -d
docker-compose down
docker-compose ps  # require docker-compose.yml
# flow
# volumes & use docker-compose
docker run -p 3000:3000 -v /app/node_modules -v $(pwd):/app  spp/green
docker exec -it 046be8cb5ba2 npm run test
docker attach 0f9e310c2c94
# multi-step build process
git remote add origin git@github.com:sppiotrowski/green-react.git

# browserstack
javascript:document.cookie="authObject=%7B%22token%22%3A%2272e73e7e3188480a9c33221f21968c63%22%2C%22userId%22%3A1044551162%7D";void(0);
javascript:document.cookie="authObject=%7B%22token%22%3A%22ed99a6b6e9b94600aec06d66875943dc%22%2C%22userId%22%3A%221060871685%22%7DuserId%22%3A1044551162%7D";void(0);
# k8s => new app
1. add docker coinfig: Dockerfile
2. create new config map for k8s
https://outfittery.atlassian.net/wiki/spaces/IT/pages/144290524/Configmaps
* init new configMap:
KUBECONFIG='/opt/k8s/k8s_automation.conf' kubectl create configmap homepage-1 --from-literal=nginx.conf="change-me-later" -n nrg
* edit
/opt/bin/k8s_edit_configmap.sh nrg homepage
* check
https://staging-kubernetes-dashboard.dev.outfittery.de/#!/configmap/nrg/homepage-1?namespace=nrg

3. use templates for a new app using this guide:
https://github.com/paulsecret/ps-kubernetes/tree/master/application_templates

5. create jenkins job (see: build homepage image)

4. access page to check
http://staging01-homepage-1.apps.outfittery.de:23080

# js
```
yarn global add prettier
prettier --single-quote --trailing-comma es5 --write "src/**/*.js"

# lodash: array to object
_.reduce(['a','b','c'], (acc, x) => {return _.assign(acc, {[x]:false})}, {})
```

# npm
generate-tmp-project:
	mkdir -p $(TMP_DIR) && cd $(TMP_DIR) \
		&& npm init --force \
		&& npm link ps-theta-jsutils \
		&& node

# sinopia
/root/.config/sinopia/storage  # storage
npm unpublish bar --force --registry "http://localhost:4873/"

# awk
# print every thing between P1(without) and P2 lines 

awk '/P1/{flag=1;next}/P2/{flag=0}flag'
# pg_dump
```
pg_dump -h 192.168.6.221 -d paul-development -U DEJu7eMHrUH3eGph6mcCSAdkUH -t direct_feedback -s
```
# generate inserts from postgresql
```
prepare dfeedback_insert as
insert into direct_feedback (id, body, customer_id, date_created, order_id, stylist_id)
    values (nextval('hibernate_sequence'), $1, $2, $3, $4, $5);

execute dfeedback_insert('test', 1, now(), 2, 3)
select * from direct_feedback order by date_created desc limit 10;

select 'insert into direct_feedback (' ||
  array_to_string(array(
    select column_name::text from information_schema.columns where table_name = 'direct_feedback'
  ), ', ')
  || ') values (select nextval(''hibernate_sequence''));';

```

# rabbit - activitiservice
```
open http://192.168.3.17:15672/#/queues/%2F/ps-app-activitiservice-hibernate-events
{
"entityId": 1023453264,
"entityClass":"com.ps.customer.order.Order",
"eventType":"POST_COMMIT_UPDATE",
"context":{"application":"ps-app-logistics","meta":[]},
"stateChange":{"state":{"oldState":128,"newState":256}}
}

nohup ls &>/dev/null &
nohup ls & disown
```
# outfitbrowser-frontend
SERVICE_HOST="https://outfitbroer-backend.apps.outfittery.de" npm start
open http://localhost:8080/?customerId=62282967

# start new frontend app
- I have already: npm, nodejs
- create from scratch or... use 'yo' and 'generator-react-webpack-redux'
# http://yeoman.io/
npm install -g yo
# get generator
npm install -g generator-react-webpack-redux
# yo man with SCSS
cd ~/projects && mkdir green-app && cd green-app && yo react-webpack-redux

sudo -upostgres psql paul-production
# amidala
## i18n

```
messages_library.json.gsp => "sanity.check.article.msgbox.title": "<g:message code="sanity.check.article.msgbox.title" />"
grails-app/i18n/javascript_en.properties => sanity.check.article.msgbox.title=Article sanity check
vim +24 web-app/MyApp/helper/Localizer.js => t = Ext.bind(me.get,me);
  
```

# task
{  
   "address":"com.ps.taskmanager.stylist.test.tanja@test.de",
   "body":{  
      "assignee":"test.tanja@test.de",
      "taskId":"ebc709e7-a50c-11e7-9548-00163e0aa898",
      "taskType":"OFFLINE",
      "taskActions":[  
         {  
            "actionType":"MESSAGE",
            "actionValue":"ScheduleDFC"
         },
         {  
            "actionType":"MESSAGE",
            "actionValue":"Reassign"
         },
         {  
            "actionType":"CONFIRMATION",
            "actionValue":"OnHold"
         },
         {  
            "actionType":"MESSAGE",
            "actionValue":"CancelOrder"
         }
      ],
      "processInstanceId":"d3ec9058-7a7f-11e6-ad11-00163efd4a27",
      "processDefinitionId":"OrderFlow:1:f3d9d56c-7a5f-11e6-af8a-00163e0aa898",
      "variables":{  
         "originalAssignee":null,
         "workOnOrderDate":"2017-09-29T11:54:17.192Z",
         "dateReleasedFromHold":"2017-09-29T11:54:17.185Z",
         "taskManagerMessages":"CancelOrder,Reassign,ScheduleDFC",
         "processable":true,
         "customerType":"NEW",
         "taskManagerType":"OFFLINE",
         "orderType":"NO_CALL",
         "taskManagerConfirmation":"OnHold",
         "dateOpportunityConfirmed":"2016-09-14T14:19:48.195Z",
         "confirmOrderEmailSent":true,
         "assignee":"test.tanja@test.de",
         "manualSalesChannel":false,
         "stylist":"test.diana@test.de",
         "targetState":"ENABLE_CHECKOUT",
         "customerId":277774749,
         "dateOrderCreated":"2016-09-14T13:33:27.000Z",
         "taskManagerLinks":null,
         "originator":null,
         "orderId":277774817,
         "phoneDate":null
      },
      "error":null
   }
}

# about this doc
[markdown format]: https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet

# kibana.devtools
* important: add sort by data & uid => search_after
```
"sort": [
  {
    "@timestamp": {
      "order": "desc",
      "unmapped_type": "boolean"
    }
  },{"_uid": "desc"}
],
"search_after":[1504635640785,"log4j#AV5TRd2pZOUcaU5jBfVD"]
```

# iclu
273927 - iCloudKeychain

# git & sed
for f in $(git grep -e log.error --name-only); do sed -i '' 's/log.error/log.warn/g' "$f"; done;

# TM 2.0
Requirements:
  * npm - package menager for javascript
    - uses: dependencies.json as configuration file
  * node - Node.js - js runtime (
  * eslint - static code analysis (npm install eslint)
Init project
  * clone repo
  ```
  git clone git@github.com:paulsecret/ps-app-taskmanager.git && cd ps-app-taskmanager && git checkout new_task_manager
  ```
  * install deps & run app
  ```
  npm install && npm run dev
  ```
Tech stack
  * React.js - html rendering lib
  * Reflux - uni-directional dataflow: actions -> stores -> view componets
  * lodash - js extras lib
  * webpack(webpack.config) - module boundler
    - configure entry files & output file (boundle.js)
    - configure loaders for each type of file:
      -- *.js babel
      -- *.scss *.css, => style loader
      -- file loader
      -- url loader
    - define global js variable (like jquery)
    - other plugins (like uglyfiy)
        
  * eslint - ./eslintrc.js - static analysis tool for code quality
  * gulp - gulpfile.js - task manager
    ```gulp
    get ./env/env.js 'development' replace => ./src/scripts/env.json
    ```    
  * babel
  * bootstrap - ./boostraprc - css && images lib

Arch
* build system
  ```
  npm(packages.json).scripts.dev
    => gulp development => cp ./env/env/json(development) ./src/scripts/env.json
    => webpack-dev-server => run webpack server on localhost:8080
      => webpack
        => babel(.babelrc)
          => presets (enable babel presets)
            * latest (default tools)
            * react (react js)
            * stage-3 (enable ES6 stage: async / await)
          => plugins 
            * transform-runtime (enable ES6)
        => bootstrap-webpack (.bootstraprc) - enable/disable bootstrap components for prod/dev
  ```
* project
  ```
  app.js (app entry) - define react-dom (Browser Client) as React default rendering client
    * render() - main render
  ```

# Jenkinsfile tip & tricks
* how to stop execution
currentBuild.result = 'ABORTED'
error('Stopping early…')
@NonCPS

# idea
clean recent files
```
TODAY="$(date "+%Y-%m-%d")"
mv .idea/workspace.xml .idea/workspace.xml.${TODAY}.back
```
ideaMac file
for f in $(git diff origin/master..HEAD --name-only); do ideaMac $f; done;


# outfittery
# new order for s.p.piotrowski (prod)
open https://admin.apps.outfittery.de/order/create?customer.id=323931956

# console
* record animated gif
ttyrec myfile
CTRL+D
ttygif myfile

# javatools
* jvisualvm

# docker
```
open https://docs.docker.com/compose/reference/overview

docker-compose exec prometheus sh  # connect to service shell
docker-compose up -d  # start as a demon
docker-compose stop
docker ps
```

# vim
```
# vim regexp
:15,21s/\(.*\)/\1: {id: 'labels.\1', defaultMessage: '\1'}/g

# execute cmd and exit
vim -c ':1,1d | x' file.txt

# change in many buffers
:bufdo %s/pattern/replace/ge | update

# load .bashrc in ! mode
:set shellcmdflag=-ic

# open with first word
vim -c '/amidala' /srv/pillar/common.sls

# execute current line in bash
:exec '!'.getline('.')
:.w !bash
!!bash

# replace """ "a" """ => """ \"a\" """
:%s/"""\zs.\{-}\ze"""/\=substitute(submatch(0), '"', '\\"', 'g')/
```

# [workflow tomcat]
catalina start/stop
/usr/local/opt/tomcat@7/libexec/webapps/
/Users/spi/projects/ps-app-workflow/target/ps-app-workflow.war
mvn clean package && 

# bash
```
# show permissions as octal value
stat -c "%a %n" ./somefile

# wrap command
function mytest {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo "error with $1" >&2
    fi
    return $status
}

mytest $command1
mytest $command2
```
# [bash builtins]
`
(cmd; cmd; cmd)  # cmds are executed in subshell
$(cmd)           # cmd substitution
set -- one two three  # sets $1 $2 $3
`

# bash - globbing wildcards
for l in $(ls ./*{DE,AT,CH,LU}*);do echo $l; done
sed -i '' -e "s/OUTFITTERY - Einfach Gut Aussehen/Outfittery - Dein Stil. Dein Weg./" *{DE,AT,CH,LU}*

# salt
```
# target by grains
salt -C 'G@app_owner:theta and G@app_type:springboot' grains.item app_name
salt -C 'G@app_owner:theta and not G@app_type:grails and not G@app_type:springboot' grains.item app_name | grep ps- | sort | uniq

# minion does not respond
service salt-minion restart

# apply state.sls
```
salt '*' state.sls <modulename>

# git
# show diff between to branches (print only commits)
git log --oneline --graph origin/master..develop

git log --oneline --decorate --left-right --graph master...origin/master

# internals
ps_ci "$(.pr.current)" "$(.git.current)" prod

# accept theirs changes in a conflict
# warn: git rebase => theirs = ours
git checkout --theirs path/to/file # ours
```

# js
* global vars
```js
foo() {
 let a = 1
 b = 2 // it will become global var
}
```
