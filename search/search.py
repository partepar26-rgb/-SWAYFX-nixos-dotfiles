#!/usr/bin/env python3
import sys
import json
import os
import subprocess

CACHE_FILE = os.path.expanduser("~/.cache/nix_package_cache.json")

def build_cache():
    print("󰞌 DB was outdate or doest exits, making new...")
    print("this took 1-2 minutes")
    try:
        # Генерируем структурированный JSON со всеми пакетами системы
        result = subprocess.run(
            ["nix-env", "-qa", "--json", "--description"],
            capture_output=True,
            text=True,
            check=True
        )
        
        # Сохраняем в кэш-файл
        raw_data = json.loads(result.stdout)
        
        # Оптимизируем структуру для быстрого поиска
        clean_cache = {}
        for attr, info in raw_data.items():
            clean_cache[attr] = {
                "name": info.get("name", attr),
                "desc": info.get("description", "No description")
            }
            
        with open(CACHE_FILE, "w", encoding="utf-8") as f:
            json.dump(clean_cache, f, ensure_ascii=False, indent=2)
            
        print(" Index was succesfuly created and saved!")
    except Exception as e:
        print(f" Creating cache error: {e}")
        sys.exit(1)

def search_package(query):
    if not os.path.exists(CACHE_FILE):
        build_cache()
        
    with open(CACHE_FILE, "r", encoding="utf-8") as f:
        cache = json.load(f)
        
    print(f"󰍉 Search '{query}':\n")
    found = 0
    query = query.lower()
    
    for attr, info in cache.items():
        # Ищем совпадения в названии пакета или его описании
        if query in attr.lower() or query in info["name"].lower():
            print(f" \033[1;32m{info['name']}\033[0m")
            print(f"   Attribute: {attr}")
            print(f"   {info['desc']}")
            print(" " * 50)
            found += 1
            
            # Ограничиваем вывод, чтобы не забивать терминал
            if found >= 10:
                print("First 10 seraching results. Be more precise.")
                break
                
    if found == 0:
        print(f"  Nothing found. '{query}'.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Using:")
        print("  ./fast_search.py *name*     - search")
        print("  ./fast_search.py --update  - DB update")
        sys.exit(1)
        
    if sys.argv[1] == "--update":
        build_cache()
    else:
        search_query = " ".join(sys.argv[1:])
        search_package(search_query)
