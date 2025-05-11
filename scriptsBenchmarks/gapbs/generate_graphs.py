import os
import re
import csv
import shutil
import matplotlib.pyplot as plt

def parse_stats_file(file_path):
    if not os.path.exists(file_path):
        print(f"Error: File '{file_path}' does not exist.")
        return None

    benchmarks = {}
    # Updated regex pattern to capture only the benchmark name after 'Processing ./'
    benchmark_pattern = re.compile(r"Processing .*/(.+?)\.ll")
    stats_pattern = re.compile(r"\((?P<labels>[^)]+)\): (?P<values>.+)")

    current_benchmark = None
    current_function = None

    def parse_stats_line(line):
        match = stats_pattern.search(line)
        if not match:
            return None
        keys = [k.strip() for k in match.group("labels").split(",")]
        values = [float(v.strip()) if '.' in v else int(v.strip()) for v in match.group("values").split(",")]
        return dict(zip(keys, values))

    with open(file_path, 'r') as file:
        for line in file:
            line = line.strip()
            if not line or line.startswith("#"):
                continue

            match = benchmark_pattern.search(line)
            if match:
                # Capture the benchmark name from the path and strip any unwanted characters
                current_benchmark = match.group(1).strip()
                benchmarks[current_benchmark] = {
                    "functions": {},
                    "global_stats": None
                }
                continue

            if current_benchmark:
                if line.startswith("Analyzing:"):
                    current_function = line.split("Analyzing:")[-1].strip()

                elif line.startswith("Function stats") and current_function:
                    benchmarks[current_benchmark]["functions"][current_function] = parse_stats_line(line)

                elif line.startswith("Global stats"):
                    benchmarks[current_benchmark]["global_stats"] = parse_stats_line(line)

    return benchmarks


def create_results_folder():
    # Check if results folder exists and delete it
    results_folder = "results"
    if os.path.exists(results_folder):
        shutil.rmtree(results_folder)
        print(f"Deleted existing '{results_folder}' folder.")

    # Create the results folder
    os.makedirs(results_folder)
    print(f"Created new '{results_folder}' folder.")


def write_stats_to_csv(stats, output_file="results/stats.csv"):
    # Determine all possible stat keys
    all_keys = set()
    for data in stats.values():
        if data["global_stats"]:
            all_keys.update(data["global_stats"].keys())
        for func_data in data["functions"].values():
            all_keys.update(func_data.keys())

    fieldnames = ["benchmark", "function"] + sorted(all_keys)

    with open(output_file, "w", newline="") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()

        for benchmark, data in stats.items():
            # Write global stats row
            if data["global_stats"]:
                row = {"benchmark": benchmark, "function": "__GLOBAL__"}
                row.update(data["global_stats"])
                writer.writerow(row)

            # Write function rows
            for func_name, func_stats in data["functions"].items():
                row = {"benchmark": benchmark, "function": func_name}
                row.update(func_stats)
                writer.writerow(row)


def plot_top_ai_functions(stats):
    for benchmark, data in stats.items():
        function_stats = data["functions"]

        # Extract AI per function
        ai_list = [
            (func_name, func_data.get("AI", 0))
            for func_name, func_data in function_stats.items()
        ]

        # Sort by AI descending and take top 5
        top_functions = sorted(ai_list, key=lambda x: x[1], reverse=True)[:5]

        if not top_functions:
            print(f"No functions with AI data found for benchmark: {benchmark}")
            continue

        func_names = [f for f, _ in top_functions]
        ai_values = [ai for _, ai in top_functions]

        # Plot
        plt.figure(figsize=(10, 6))
        bars = plt.bar(func_names, ai_values, color='steelblue')
        plt.title(f"Top 5 Functions by AI - {benchmark}")
        plt.ylabel("Arithmetic Intensity (AI)")
        plt.xlabel("Function Name")
        plt.xticks(rotation=45, ha="right")
        plt.tight_layout()

        # Add value labels above bars
        for bar in bars:
            height = bar.get_height()
            plt.text(bar.get_x() + bar.get_width() / 2, height + 0.002, f"{height:.5f}", ha='center', va='bottom', fontsize=8)

        output_file = f"results/ai_{benchmark}.png"
        plt.savefig(output_file)
        plt.close()

        print(f"Saved plot for {benchmark} to {output_file}")


def plot_summary_ai(stats):
    benchmarks = []
    global_ais = []
    top_func_ais = []

    for benchmark, data in stats.items():
        benchmarks.append(benchmark)

        # Get global AI
        global_ai = data["global_stats"].get("AI", 0) if data["global_stats"] else 0
        global_ais.append(global_ai)

        # Get max AI from functions
        max_func_ai = max(
            (func_data.get("AI", 0) for func_data in data["functions"].values()),
            default=0
        )
        top_func_ais.append(max_func_ai)

    x = range(len(benchmarks))
    width = 0.35

    plt.figure(figsize=(10, 6))
    bars1 = plt.bar([i - width/2 for i in x], global_ais, width, label='Global AI', color='orange')
    bars2 = plt.bar([i + width/2 for i in x], top_func_ais, width, label='Top Function AI', color='seagreen')

    # Add value labels
    for bar in bars1 + bars2:
        height = bar.get_height()
        plt.text(bar.get_x() + bar.get_width() / 2, height + 0.002, f"{height:.5f}", ha='center', va='bottom', fontsize=8)

    plt.xticks(x, benchmarks, rotation=45, ha="right")
    plt.ylabel("Arithmetic Intensity (AI)")
    plt.title("Global vs. Top Function AI per Benchmark")
    plt.legend()
    plt.tight_layout()

    output_file = "results/summary_ai.png"
    plt.savefig(output_file)
    plt.close()
    print(f"Saved summary AI plot to {output_file}")


def main():
    # Create the results folder before any file operations
    create_results_folder()

    file_path = 'stats.txt'
    stats = parse_stats_file(file_path)

    if stats is None:
        return

    # Write CSV in the 'results' folder
    write_stats_to_csv(stats, "results/stats.csv")
    print("Stats saved to 'results/stats.csv'.")

    # Plot the top AI functions for each benchmark
    plot_top_ai_functions(stats)

    # Plot the summary AI graph
    plot_summary_ai(stats)


if __name__ == "__main__":
    main()


