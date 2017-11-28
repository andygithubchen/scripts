<?php

class WatchPhpErrorClass{
    const rememberLastLen = '/var/.rememberLastLen.txt';
    public $File   = '';
    public $server = '';
    public $SplFileObj = '';
    static $len = 0;

    public function __construct(){
        $this->File = ini_get('error_log');
        if(!file_exists($this->File))
            die('php_errors.log file is not exists');

        if(!function_exists('inotify_init'))
            die('you can "pecl install inotify" to install swoole php extension, if your php >= 7.0'.PHP_EOL);

        if(!class_exists('swoole_websocket_server'))
            die('you can "pecl install swoole" to install swoole php extension'.PHP_EOL);

        if(file_exists(self::rememberLastLen))
            self::$len = (int)file_get_contents(self::rememberLastLen);

        $this->SplFileObj = new \SplFileObject($this->File, 'r');
        $this->server = new swoole_websocket_server("192.168.0.104", 1010);
        $this->server->set(array(
            'ssl_cert_file' => '/root/tmp/ca/private/ca.crt',
            'ssl_key_file'  => '/root/tmp/ca/private/ca.key',
        ));
    }

    public function run(){
        //$this->server->on('open', $this->watchPhpError);

        $this->server->on('open', function(){
            $msg = '';
            $inotify = inotify_init();
            $watch_errorLog = inotify_add_watch($inotify, $this->File, IN_MODIFY);
            swoole_event_add($inotify, function($inotify){
                $events = inotify_read($inotify);
                if($events){
                    $msg = $this->_getErrorInfo();
                    foreach($this->server->connections as $fd){
                        $this->server->push($fd, json_encode($msg));
                    }
                }
            });

        });

        $this->server->on('message', function($server, $frame) {
        });

        $this->server->on('close', function($server, $fd) {
            echo "PHP connection close: {$fd}\n";
        });
        $this->server->start();
    }

    public function watchPhpError(){
        foreach($this->server->connections as $fd){
            $this->server->push($fd, json_encode(["hello", "world"]));
        }
    }

    public function _getErrorInfo(){
        $data = [];
        $this->SplFileObj->seek(PHP_INT_MAX);
        $_len = $this->SplFileObj->key();
        $content = new \LimitIterator($this->SplFileObj, (int)self::$len, $_len);
        file_put_contents(self::rememberLastLen, $_len);
        self::$len = $_len;
        foreach($content as $k=>$value){
            $_arr = explode('] PHP', $value);
            if(isset($_arr[1])){
                $_str = explode(' ', trim(explode(':', $_arr[1])[0]));
                $_str = end($_str);
                isset($data[$_str]) ? ++$data[$_str] : $data[$_str] = 1;
            }
        }
        $data['unkown'] = isset($k) ? $k+1 - array_sum($data) : 0;
        return $data;
    }

}

$obj = new WatchPhpErrorClass();
$obj->run();



